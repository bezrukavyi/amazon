class HumanPasswordValidator < ActiveModel::EachValidator
  INSPECTION = /\A(?=.*\d)(?=.*[A-Z])(?=.*[a-z])\w+{,8}\z/

  def validate_each(object, attribute, value)
    return if value =~ INSPECTION
    object.errors.add(attribute,
                      I18n.t('validators.human.password.base_regexp'))
  end

  def self.generate_password
    symbols = [(0..9), ('A'..'Z'), ('a'..'z')].map(&:to_a).flatten
    (0...50).map { symbols[rand(symbols.length)] }.join
  end
end
