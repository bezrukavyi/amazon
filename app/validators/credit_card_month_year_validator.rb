class CreditCardMonthYearValidator < ActiveModel::EachValidator
  INSPECTIONS = [:slash_format, :month_format, :year_format].freeze

  def validate_each(object, attribute, value)
    INSPECTIONS.each do |inspection|
      next if send(inspection, value)
      object.errors.add(attribute,
                        I18n.t("validators.credit_card.#{inspection}"))
    end
  end

  private

  def slash_format(value)
    value =~ %r{\A\d+\/\d+\z}
  end

  def month_format(value)
    value =~ %r{\A(0[1-9]|1[0-2])\/}
  end

  def year_format(value)
    value =~ %r{\/\d{2}\z}
  end
end
