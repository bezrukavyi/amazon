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
  rand(2..10).times do
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
  rand(1..3).times do
    book.authors << Author.find_by(id: rand(1..Author.count))
    book.materials << Material.find_by(id: rand(1..Material.count))
  end
end
