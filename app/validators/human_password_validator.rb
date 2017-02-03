class HumanPasswordValidator < ActiveModel::EachValidator

  INSPECTION = /\A(?=.*\d)(?=.*[A-Z])(?=.*[a-z])\w+{,8}\z/

  def validate_each(object, attribute, value)
    if value.present? && value !~ INSPECTION
      object.errors.add(attribute, I18n.t('validators.human.password.base_regexp'))
    end
  end


end
