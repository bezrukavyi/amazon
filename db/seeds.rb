['Mobile', 'Development', 'Photo', 'Web design', 'Web development'].each do |name|
  Category.find_or_create_by!(title: name)
end

20.times do
  first_name = FFaker::Name.first_name
  last_name = FFaker::Name.last_name
  Author.find_or_create_by!(first_name: first_name, last_name: last_name) do |author|
    author.desc = FFaker::Lorem.paragraph
  end
end

Category.find_each do |category|
  rand(5..25).times do
    title = FFaker::Book.title
    Book.find_or_create_by!(title: title) do |book|
      book.price = rand(10.00..20.00)
      book.count = rand(100..500)
      book.desc = FFaker::Book.description
      book.dimension = { "h": rand(5.0..10.0).round(1), "w": 4.4, "d": 10.0 }
      book.category = category
    end
  end
end

['glossy paper', 'wood', 'textile', 'glass'].each do |name|
  Material.find_or_create_by!(name: name)
end

Book.find_each do |book|
  book.authors = Author.last(rand(1..3))
  book.materials = Material.last(rand(1..3))
end

Country.create!(name: 'Ukraine', code: '380')

Delivery.create!(name: 'Ukrpost', country: Country.last, price: 20, min_days: 10,
  max_days: 20)
