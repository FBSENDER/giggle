class Message < ActiveRecord::Base
  has_many :notifications
  belongs_to :messageable, polymorphic: true, counter_cache: true
  belongs_to :user

  after_create :track_notification
  before_create :convert_content

  validates :content, presence: true, length: { maximum: 400 }
  validates :messageable_type, inclusion: { in: %w(Product Evaluate),
                                            message: "%{value} is not a valid type" }

  TYPE_NAME = {"Product"=>"产品", "Evaluate"=>"评测"}

  def messageable_cn
    TYPE_NAME[self.messageable_type] 
  end

  def messageable_name
    case self.messageable_type
    when "Product"
      self.messageable.try(:name)
    when "Evaluate"
      self.messageable.try(:title)
    end
  end

  def evaluate_author? notification
    notification.user == notification.message.messageable.try(:user)
  end

  def self.per_page
    10
  end

  def self.search this_params
    message = self.all
    message = message.where("content LIKE ?", "%#{this_params[:content]}%") if this_params[:content].present?
    message = message.where(messageable: Product.where("products.name Like ?", "%#{this_params[:product]}%")) if this_params[:product].present?
    message = message.where(messageable: Evaluate.where("products.name Like ?", "%#{this_params[:evaluate]}%")) if this_params[:evaluate].present?
    message = message.joins(:user).where("users.name LIKE ?", "%#{this_params[:user]}%") if this_params[:user].present?
    message = message.where(messageable_type: this_params[:messageable_type]) if this_params[:messageable_type].present?
    message.paginate(page: this_params[:page])
  end

  private

  def convert_content
    if self.content.include?("@")
      users = find_user_in_content
      users.each do |user|
        url = "[@#{user.name}](/users/#{user.id})"
        self.content.gsub!(/(@#{user.name})/, url) 
      end
    end
    self.content = markdown(self.content)
    true
  end

  def track_notification
    track_users = []
    track_users << self.messageable.user if self.messageable.try(:user).present?
    track_users += find_user_in_content
    track_users.delete(self.user)
    track_users.uniq.each do |user|
      Notification.create! user_id: user.id, message_id: self.id   
    end
  end

  def format_user_in_content
    self.content.scan(/@([\w\u4e00-\u9fa5]{2,20})/).flatten
  end

  def find_user_in_content
    User.where(name: format_user_in_content)
  end

  def markdown(text)
    markdown_render = Redcarpet::Render::HTML.new(hard_wrap: true, no_styles: true)
    markdown = Redcarpet::Markdown.new(markdown_render, autolink: true, no_intro_emphasis: true) 
    markdown.render(text).html_safe
  end
end
