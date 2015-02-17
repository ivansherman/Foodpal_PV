module ApplicationHelper

  def full_title(page_title)
    base_title = "FoodPal"
    if page_title.empty?
      base_title
    else
      "#{page_title} | #{base_title}"
    end
  end

  def flash_class(level)
    case level
      when :notice then
        "alert alert-info"
      when :success then
        "alert alert-success"
      when :error then
        "alert alert-danger"
      when :error_login then
        "alert alert-danger"
      when :alert then
        "alert alert-error"
    end
  end

  def getImage(image)
    if image
      img = image
      logo = File.exist?(Rails.root.join('public', 'images', img)) ? "/images/" + img : "/assets/imagenotavailable.png"
    else
      logo = "/assets/imagenotavailable.png"
    end

    logo
  end


end
