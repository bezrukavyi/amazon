class HumanPasswordValidator < ActiveModel::EachValidator

  INSPECTION = /\A(?=.*\d)(?=.*[A-Z])(?=.*[a-z])\w+{,8}\z/

  def validate_each(object, attribute, value)
    if value.present? && value !~ INSPECTION
      object.errors.add(attribute, I18n.t('validators.human.password.base_regexp'))
    end
  end

  def self.generate_password
    symbols = [(0..9), ('A'..'Z'), ('a'..'z')].map(&:to_a).flatten
    string = (0...50).map { symbols[rand(symbols.length)] }.join
  end


end
