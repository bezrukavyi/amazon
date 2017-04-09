module Flashable
  extend ActiveSupport::Concern

  def flash_render(template, flash_messages = {})
    support_flash = [:notice, :alert]
    flash_messages.each do |type, message|
      flash.now[type] = message if support_flash.include?(type)
    end
    render template
  end
end
