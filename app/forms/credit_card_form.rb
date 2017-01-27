class CreditCardForm < Rectify::Form

  STRING_ATTRS = [:name, :number, :cvv, :month_year]

  STRING_ATTRS.each do |name|
    attribute name, String
    validates name, presence: true
  end

  validates :name, length: { maximum: 100 },
    format: { with: /\A[a-zA-Z]+\z/ }

  validates :number, credit_card_number: true

  validates :number, :cvv, numericality: { only_integer: true }

  validates :cvv, length: { is: 3 }


  validate :slash_format, :month_format, :year_format

  private

  def slash_format
    return if month_year =~ /\A\d{2}\/\d{2}\z/
    errors.add(:month_year, "Does not match format: 'MM/YY'")
  end

  def month_format
    return if month =~ /0[1-9]|1[0-2]/
    errors.add(:month_year, "Month format with numbers from 01 to 12")
  end

  def year_format
    return if year =~ /\A\d{2}\z/
    errors.add(:month_year, "You should record the last two numbers of the year")
  end

  def month
    @month ||= month_year.split('/').first
  end

  def year
    @year ||= month_year.split('/').last
  end

end
