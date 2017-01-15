module ApplicationHelper

  def general_simple_form_for(path, options = {}, &block)
    options = options.deep_merge(html: { class: 'general-form' })
    simple_form_for(path, options, &block)
  end

end
