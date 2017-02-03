class CreditCardMonthYearValidator < ActiveModel::EachValidator

  INSPECTIONS = [:slash_format, :month_format, :year_format]

  def validate_each(object, attribute, value)
    INSPECTIONS.each do |inspection|
      if value.present? && !send(inspection, value) && object.errors.blank?
        object.errors.add(attribute, I18n.t("validators.credit_card.#{inspection}"))
      end
    end
  end

  private

  def slash_format(value)
    value =~ /\A\d+\/\d+\z/
  end

  def month_format(value)
    value =~ /\A(0[1-9]|1[0-2])\//
  end

  def year_format(value)
    value =~ /\/\d{2}\z/
  end

end
