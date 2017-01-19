class AddressForm < Rectify::Form

  STRING_ATTRS = [:first_name, :last_name, :name, :zip, :phone, :city,
    :country_id, :addressable_type]

  INTEGER_ATTRS = [:addressable_id, :address_type]

  STRING_ATTRS.each do |name|
    attribute name, String
    validates name, presence: true
  end

  INTEGER_ATTRS.each do |name|
    attribute name, Integer
    validates name, presence: true
  end

  validates :phone, length: { minimum: 9, maximum: 15 },
    format: { with: /\A\+\d{9,15}\z/ }

  validates :zip, length: { maximum: 10 }, numericality: { only_integer: true }

  validates :first_name, :last_name, :city, length: { maximum: 50 },
    format: { with: /\A[a-zA-Z]+\z/ }

  validate :wrong_code

  def wrong_code
    return unless country = Country.find_by_id(country_id)
    return if phone =~ /^\+#{country.code}/
    errors.add(:phone, I18n.t('simple_form.error_notification.country_code',
      code: "+#{country.code}"))
  end

end
