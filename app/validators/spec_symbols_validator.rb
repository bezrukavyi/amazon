class SpecSymbolsValidator < ActiveModel::EachValidator
  INSPECTION = /[!%$&?'`*^._=~+-\{\|\}\#\/]/

  def validate_each(object, attribute, value)
    return if value =~ /\A[\w\s]+#{INSPECTION}?[\w\s]*\z/
    object.errors.add(attribute, I18n.t('validators.spec_symbols.base_regexp'))
  end
end
