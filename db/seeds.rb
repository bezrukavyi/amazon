DAYS = 150
DEMAND = 0..10

['Mobile', 'Development', 'Photo', 'Web design'].each do |name|
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
  title = FFaker::Book.title
  Book.find_or_create_by!(title: title) do |book|
    book.price = rand(10.00..20.00)
    book.count = rand(50..100)
    book.desc = FFaker::Book.description
    book.dimension = { "h": rand(5.0..10.0).round(1), "w": 4.4, "d": 10.0 }
    book.category = category
    book.inventory = Corzinus::Inventory.create(count: book.count)
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
  %w(Standart Express).each do |delivery_name|
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

User.find_each do |user|
  created_card = Corzinus::CreditCard.find_or_create_by!(number: 5_274_576_394_259_961, person: user) do |card|
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
    shipping.zip = 49_000
    shipping.country = country
    shipping.phone = "+#{country.code}632863823"
  end

  user.billing = Corzinus::Address.create! do |billing|
    billing.address_type = 'billing'
    billing.first_name = FFaker::Name.first_name
    billing.last_name = FFaker::Name.last_name
    billing.name = FFaker::Address.street_name
    billing.city = 'Dnepr'
    billing.zip = 49_000
    billing.country = country
    billing.phone = "+#{country.code}632863823"
  end

  DAYS.downto(0) do |day_number|
    date = DateTime.now - day_number.to_i.day

    rand(1..3).times do
      created_order = Corzinus::Order.create! do |order|
        order.credit_card = created_card.dup
        order.shipping = user.shipping.dup
        order.billing = user.billing.dup
        order.delivery = country.deliveries.first
        order.created_at = date
      end

      Corzinus::OrderItem.create do |item|
        item.quantity = rand(DEMAND)
        item.productable_id = rand(1..Book.count)
        item.productable_type = 'Book'
        created_order.order_items << item
      end

      created_order.confirm!
      user.orders << created_order
    end

    Book.all.each do |book|
      book.inventory.add_sale(date)
    end
  end

  user.save!
end
