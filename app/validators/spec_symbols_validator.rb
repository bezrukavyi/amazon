class SpecSymbolsValidator < ActiveModel::EachValidator

  INSPECTION = /\w+[!%$&?'`*^._=~+-\{\|\}\#\/]?\w*/

  def validate_each(object, attribute, value)
    if value !~ /\A#{INSPECTION}\z/
      object.errors.add(attribute, I18n.t('validators.spec_symbols.base_regexp'))
    end
  end

end
