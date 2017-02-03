class HumanNameValidator < ActiveModel::EachValidator

  SUPP_SYMBOLS = /[a-zA-z]/

  def validate_each(object, attribute, value)
    inspection = options[:with] || :one
    if value !~ send(inspection) && object.errors.blank? && !value.blank?
      object.errors.add(attribute, I18n.t("validators.human.name.base_regexp"))
    end
  end

  private

  def one
    /\A#{SUPP_SYMBOLS}+\z/
  end

  def few
    /\A#{SUPP_SYMBOLS}+(?>.*[\s])*#{SUPP_SYMBOLS}+\z/
  end

end
