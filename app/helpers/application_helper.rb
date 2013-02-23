module ApplicationHelper
  FLASH_TYPES = [:error, :warning, :success, :message]
  
  def display_flash(type = nil)
    if type.nil?
      FLASH_TYPES.map{|t| display_flash(t)}.compact.join('<br/>')
    else
      content_tag(:div, flash[type], class: type) unless flash[type].blank?
    end
  end
  
  def modal(opts = { :id => nil, :width => 500 }, &block)
    content_tag(:div, class: 'modal', id: opts[:id]) do
      "<div class=\"modal-overlay\"></div>".html_safe +
      content_tag(:div, class: 'modal-wrap') do
        content_tag(:div, class: 'modal-inner', style: "width: #{opts[:width]}px;") do
          yield
        end
      end
    end
  end
  
  def modal_link(text, id)
    link_to(text, '#', rel: 'modal', data: { modal: id })
  end
end
