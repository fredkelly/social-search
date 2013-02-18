module ApplicationHelper
  FLASH_TYPES = [:error, :warning, :success, :message]
  
  def display_flash(type = nil)
    if type.nil?
      FLASH_TYPES.map{|t| display_flash(t)}.join
    else
      content_tag(:div, flash[type], class: type) unless flash[type].blank?
    end
  end
end
