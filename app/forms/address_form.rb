class AddressForm < Rectify::Form
  STRING_ATTRS = [:first_name, :last_name, :name, :zip, :phone, :city].freeze
  INTEGER_ATTRS = [:country_id, :address_type].freeze

  STRING_ATTRS.each do |name|
    attribute name, String
    validates name, presence: true
  end

  INTEGER_ATTRS.each do |name|
    attribute name, Integer
    validates name, presence: true
  end

  validates :name, length: { maximum: 50 }, address: { name: true }
  validates :zip, length: { maximum: 10 }, address: { zip: true }
  validates :phone, length: { minimum: 9, maximum: 15 },
                    format: { with: /\A\+\d{9,15}\z/ }
  validates :first_name, :last_name, :city, length: { maximum: 50 },
                                            human_name: :one

  validate :wrong_code

  private

  def wrong_code
    return unless country = Country.find_by_id(country_id)
    return if phone =~ /\A\+#{country.code}/
    errors.add(:phone, I18n.t('simple_form.error_notification.country_code',
                              code: "+#{country.code}"))
  end
end
