class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  helper FontAwesome::Rails::IconHelper
  helper SessionsHelper
  helper LikeshipsHelper
  helper UserPicturesHelper
  protect_from_forgery with: :exception
  include SessionsHelper

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_url, danger: exception.message
  end

  rescue_from ActionController::RoutingError, :with => :render_to_404
  rescue_from ActiveRecord::RecordNotFound, :with => :render_to_404

  private

  def render_to_404 
    render :template => "errors/404"
  end
end
