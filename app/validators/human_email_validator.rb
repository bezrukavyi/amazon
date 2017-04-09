class HumanEmailValidator < ActiveModel::EachValidator
  SUPP_SYMBOLS = SpecSymbolsValidator::INSPECTION
  DOMAIN = /@[\w\-.]+\.[a-z]+/
  INSPECTIONS = [:base_regexp, :dot_regexp, :symbols_regexp].freeze

  def validate_each(object, attribute, value)
    INSPECTIONS.each do |inspection|
      next if value =~ send(inspection)
      object.errors.add(attribute,
                        I18n.t("validators.human.email.#{inspection}"))
    end
  end

  private

  def base_regexp
    /\A.+#{DOMAIN}\z/
  end

  def symbols_regexp
    /\A\w+#{SUPP_SYMBOLS}?\w*#{DOMAIN}\z/
  end

  def dot_regexp
    /\A(?!\.)+.*(?<!\.)+#{DOMAIN}\z/
  end
end
