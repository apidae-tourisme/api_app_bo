module SeedHelper
  extend ActionView::Helpers::OutputSafetyHelper

  def fa_icon(names = "flag", options = {})
    classes = ["fa"]
    classes.concat icon_names(names)
    classes.concat Array(options.delete(:class))
    text = options.delete(:text)
    right_icon = options.delete(:right)
    icon = content_tag(:i, nil, options.merge(:class => classes))
    icon_join(icon, text, right_icon)
  end

  def icon_join(icon, text, reverse_order = false)
    return icon if text.blank?
    elements = [icon, ERB::Util.html_escape(text)]
    elements.reverse! if reverse_order
    safe_join(elements, " ")
  end

  def icon_names(names = [])
    array_value(names).map { |n| "fa-#{n}" }
  end

  def array_value(value = [])
    value.is_a?(Array) ? value : value.to_s.split(/\s+/)
  end
end
