require 'rails_helper'

RSpec.describe Book, type: :model do

  subject { build :book }

  context 'association' do
    it { should belong_to :category }
    it { should have_and_belong_to_many :authors }
    it { should have_and_belong_to_many :materials }
    it { should have_many :pictures }
    it { should have_many :reviews }
  end

  context 'validation' do
    [:title, :price, :count].each do |attribute|
      it { should validate_presence_of(attribute) }
    end

    it { should validate_numericality_of(:count).is_greater_than_or_equal_to(0) }
    it { should validate_numericality_of(:price).is_greater_than(0) }

    describe '#access_dimension' do
      it 'valid' do
        subject.dimension = { "h": 10.2, "w": 10.2, "d": 10.1 }
        should be_valid
      end
      it 'invalid' do
        subject.dimension = { "h": 10.2, "w": 10.2, "zdsfsdf": 10.1 }
        expect(subject).not_to be_valid
      end
    end
  end

  context 'Scopes' do
    before do
      @fantasy = create :category
      @drama = create :category
      @potter = create :book, price: 2.0, title: 'A title', category: @fantasy
      @ruby   = create :book, price: 3.0, title: 'D title', category: @fantasy
      @rails  = create :book, price: 1.0, title: 'C title', category: @fantasy
      @book   = create :book, price: 4.0, title: 'B title', category: @drama
    end

    describe '.with_category' do
      it 'with @fantasy' do
        expect(Book.with_category(@fantasy.title).count).to eq(3)
        [@potter, @ruby, @rails].each do |book|
          expect(Book.with_category(@fantasy.title)).to be_include(book)
        end
      end
      it 'with @drama' do
        expect(Book.with_category(@drama.title).count).to eq(1)
        expect(Book.with_category(@drama.title)).to eq([@book])
      end
    end

    describe '.sorted_by' do

      it '.asc_title' do
        answer = [@potter, @book, @rails, @ruby]
        expect(Book.sorted_by(:asc_title)).to eq(answer)
      end

      it '.desc_title' do
        answer = [@ruby, @rails, @book, @potter]
        expect(Book.sorted_by(:desc_title)).to eq(answer)
      end

      it '.newest' do
        answer = [@book, @rails, @ruby, @potter]
        expect(Book.sorted_by(:newest)).to eq(answer)
      end

      it '.low_price' do
        answer = [@rails, @potter, @ruby, @book]
        expect(Book.sorted_by(:low_price)).to eq(answer)
      end

      it '.hight_price' do
        answer = [@book, @ruby, @potter, @rails]
        expect(Book.sorted_by(:hight_price)).to eq(answer)
      end
    end
  end

  describe '#in_stock?' do
    it 'true' do
      subject.count = 1
      expect(subject.in_stock?).to be_truthy
    end
    it 'true' do
      subject.count = 0
      expect(subject.in_stock?).to be_falsey
    end
  end

  it '.best_sellers' do
    @jruby = create :book
    @rails = create :book
    @rspec = create :book
    20.times do
      create :order, state: :in_progress, order_items:
        [create(:order_item, book: @jruby, quantity: 1)]
    end
    5.times do
      create :order, state: :delivered, order_items:
        [create(:order_item, book: @jruby, quantity: 1)]
    end
    10.times do
      create :order, state: :delivered, order_items:
        [create(:order_item, book: @rails, quantity: 1)]
    end
    15.times do
      create :order, state: :delivered, order_items:
        [create(:order_item, book: @rspec, quantity: 1)]
    end
    expect(Book.best_sellers).to eq([@rspec, @rails, @jruby])
  end


  describe '.filter_with' do
    before do
      @horror = create :category
      @drama = create :category
      @harry_potter = create(:book, category: @horror, price: 25.0)
      @ruby_way = create(:book, category: @horror, price: 50.0)
      @rails_way = create(:book, category: @drama, price: 100.0)
      @book = create(:book, category: @horror, price: 75.0)
    end

    it 'without options' do
      options = {}
      expect(Book.filter_with(options)).to eq(Book.asc_title)
    end

    it 'with_category' do
      options = { with_category: @horror.title }
      expect(Book.filter_with(options).count).to eq(3)
    end

    it 'sorted_by' do
      options = { sorted_by: 'hight_price' }
      expect(Book.filter_with(options)).to eq([@rails_way, @book, @ruby_way, @harry_potter])
    end

    it 'with_category and sorted_by' do
      options = { sorted_by: 'low_price', with_category: @horror.title }
      expect(Book.filter_with(options)).to eq([@harry_potter, @ruby_way, @book])
    end

  end

end
