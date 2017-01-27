class CreditCardForm < Rectify::Form

  STRING_ATTRS = [:name, :number, :cvv]
  INTEGER_ATTRS = [:year, :month]

  STRING_ATTRS.each do |name|
    attribute name, String
    validates name, presence: true
  end

  INTEGER_ATTRS.each do |name|
    attribute name, Integer
    validates name, presence: true
  end

  validates :name, length: { maximum: 50 },
    format: { with: /\A[a-zA-Z]+\z/ }

  validates :number, credit_card_number: true

  validates :number, :cvv, :year, numericality: { only_integer: true }

  validates :cvv, length: { is: 3 }

  validates_numericality_of :month, greater_than_or_equal_to: 1,
    less_than_or_equal_to: 12

  validates_numericality_of :year, greater_than_or_equal_to: Time.now.year,
    less_than_or_equal_to: 5.years.from_now.year

  def greater_than_or_equal_to_current_year
    validate_year = Time.now.year
    return if year >= validate_year
    errors.add(:year, "Year cant be less than #{validate_year}")
  end

  def less_than_or_equal_to_five_years_from_now
    validate_year = 5.years.from_now.year
    return if year <= validate_year
    errors.add(:year, "Year cant be greater than #{validate_year}")
  end


end
