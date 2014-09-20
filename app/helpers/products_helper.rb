module ProductsHelper
  def product_collection_tag product
    return fa_icon("bookmark") if current_user.blank?
    class_name = "icon_mark_select"
    link_title = "收藏"
    link_path_method = "post"
    if current_user and current_user.collectionship_product_ids.include?(product.id)
      class_name = "icon_mark_selected"
      link_title = "取消收藏"
      link_path_method = "delete"
    end
    link_to fa_icon("bookmark"), product_collectionship_path(product), class: class_name, "data-toggle"=>"tooltip", title: link_title, method: link_path_method, remote: true
  end  

  def index_title(current_category)
    if params[:sort] == "price" && params[:direction] == "asc"
      part_1 = "便宜的"
      part_2 = "性价比高的"
    elsif params[:sort] == "price" && params[:direction] == "desc"
      part_1 = "高端的"
      part_2 = "高功效的"
    elsif params[:sort] == "published_at" && params[:direction] == "asc"
      part_1 = "最新款"
      part_2 = ""
    elsif params[:sort] == "published_at" && params[:direction] == "desc"
      part_1 = "经典款"
      part_2 = ""
    else
      part_1 = ""
      part_2 = ""
    end
    if current_category.nil?
      title("#{part_1}空气净化器_#{part_2}空气净化机_AirClean")
    else
      title("#{part_1}#{part_2}#{current_category.name}")
    end
  end 

  def index_desc(current_category)
    if current_category.nil?
      head_desc("空气净化器又称空气清洁器、空气净化机、空气清洁机，是指能够吸附、分解或转化各种空气污染物（一般包括PM2.5、粉尘、花粉、异味、甲醛之类的装修污染、细菌、过敏原等），有效提高空气清洁度的产品，主要分为家用 、商用、工业、楼宇。当下PM2.5污染严重，家里或是办公环境添置一台合适的空气净化器，能够有效的净化空气，去除PM2.5，保证大家的健康。")
    else
      head_desc(strip_tags(current_category.product_category_info.details).truncate(100)) if current_category.product_category_info && current_category.product_category_info.details
    end
  end

  def index_keyword(current_category)
    if current_category.nil?
      head_keyword("空气净化器,空气净化机")
    else
      head_keyword((current_category.name.split('_') << '空气净化器').join(','))
    end
  end

  def index_head(current_category)
    index_title(current_category)
    index_desc(current_category)
    index_keyword(current_category)
  end

  def show_head(product)
    title(product.name)
    head_desc(product.description)
    head_keyword((product.name.split('_') << product.name).join(','))
  end

end
