class HumanNameValidator < ActiveModel::EachValidator
  SUPP_SYMBOLS = /[[:alpha:]]/

  def validate_each(object, attribute, value)
    inspection = options[:with] || :one
    return if value.blank? || value =~ send(inspection)
    object.errors.add(attribute, I18n.t('validators.human.name.base_regexp'))
  end

  private

  def one
    /\A#{SUPP_SYMBOLS}+\z/
  end

  def few
    /\A#{SUPP_SYMBOLS}+(?>.*[\s])*#{SUPP_SYMBOLS}+\z/
  end
end
