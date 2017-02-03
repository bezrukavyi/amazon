class HumanEmailValidator < ActiveModel::EachValidator

  SUPP_SYMBOLS = /[!%$&?'`*^._=~+-\{\|\}\#\/]/
  DOMAIN = /@[\w\-.]+\.[a-z]+\z/

  INSPECTIONS = [:base_regexp, :dot_regexp, :symbols_regexp]

  def validate_each(object, attribute, value)
    INSPECTIONS.each do |inspection|
      if value !~ send(inspection) && object.errors.blank?
        object.errors.add(attribute, I18n.t("validators.human.email.#{inspection}"))
      end
    end
  end

  private

  def base_regexp
    /\A.+#{DOMAIN}/
  end

  def symbols_regexp
    /\A\w+#{SUPP_SYMBOLS}?\w*#{DOMAIN}/
  end

  def dot_regexp
    /\A(?!\.)+.*(?<!\.)+#{DOMAIN}/
  end

end
