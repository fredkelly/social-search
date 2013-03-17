module ApplicationHelper
  FLASH_TYPES = [:error, :warning, :success, :message]
  
  def display_flash(type = nil)
    if type.nil?
      FLASH_TYPES.map{|t| display_flash(t)}.compact.join('<br/>')
    else
      content_tag(:div, flash[type], class: type) unless flash[type].blank?
    end
  end
  
  def static_map(longitude, latitude, opts = { :width => 300, :height => 300})
    image_tag("http://maps.google.com/maps/api/staticmap?size=#{opts[:width]}x#{opts[:height]}&sensor=false&zoom=10&markers=#{latitude}%2C#{longitude}", opts)
  end
  
  def image_url(source)
    URI.join(root_url, image_path(source))
  end
end
