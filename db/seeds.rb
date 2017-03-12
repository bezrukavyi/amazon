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

{ 'Ukraine': '380', 'Russia': '230' }.each do |name, code|
  Corzinus::Country.find_or_create_by!(name: name, code: code)
end

Corzinus::Country.find_each do |country|
  %w[Standart Express].each do |delivery_name|
    Corzinus::Delivery.find_or_create_by!(name: "#{country.name}#{delivery_name}") do |delivery|
      delivery.country = country
      delivery.price = rand(30..100)
      delivery.min_days = rand(5..10)
      delivery.max_days = rand(15..20)
    end
  end
end

User.find_or_create_by!(email: 'yaroslav555@gmail.com') do |user|
  user.password = 'Password555'
  user.password_confirmation = 'Password555'
  user.admin = true
end

ORDER_STATES = [:in_progress, :in_transit, :delivered, :canceled]

User.find_each do |user|

  card = Corzinus::CreditCard.find_or_create_by!(number: 5274576394259961, person: user) do |card|
    card.name = FFaker::Name.first_name
    card.cvv = '123'
    card.month_year = '12/17'
  end

  country = Corzinus::Country.find(rand(1..Corzinus::Country.count))

  user.shipping = Corzinus::Address.create! do |shipping|
    shipping.address_type = 'shipping'
    shipping.first_name = FFaker::Name.first_name
    shipping.last_name = FFaker::Name.last_name
    shipping.name = FFaker::Address.street_name
    shipping.city = 'Dnepr'
    shipping.zip = 49000
    shipping.country = country
    shipping.phone = "+#{country.code}632863823"
  end

  user.billing = Corzinus::Address.create! do |billing|
    billing.address_type = 'billing'
    billing.first_name = FFaker::Name.first_name
    billing.last_name = FFaker::Name.last_name
    billing.name = FFaker::Address.street_name
    billing.city = 'Dnepr'
    billing.zip = 49000
    billing.country = country
    billing.phone = "+#{country.code}632863823"
  end

  rand(3..6).times do

    order = Corzinus::Order.create! do |order|
      order.credit_card = card.dup
      order.shipping = user.shipping.dup
      order.billing = user.billing.dup
      order.delivery = country.deliveries.first
      order.state = ORDER_STATES[rand(0..3)]
    end

    rand(1..5).times do
      item = Corzinus::OrderItem.create! do |item|
        item.quantity = rand(1..3)
        item.productable_id = rand(1..Book.count)
        item.productable_type = 'Book'
        order.order_items << item
      end

      user.orders << order
    end
  end

  user.save!
end
