module CountriesHelper
  def countries_options(countries)
    countries.map do |country|
      [country.name, country.id, { data: { code: country.code } }]
    end
  end
end
