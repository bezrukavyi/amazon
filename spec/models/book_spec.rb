describe Book, type: :model do
  subject { build :book }

  context 'association' do
    it { should belong_to :category }
    it { should have_and_belong_to_many :authors }
    it { should have_and_belong_to_many :materials }
    it { should have_many :pictures }
    it { should have_many :reviews }
  end

  context 'validation' do
    %i(title price).each do |attribute|
      it { should validate_presence_of(attribute) }
    end
    it { should validate_numericality_of(:price).is_greater_than(0) }

    describe '#access_dimension' do
      it 'valid' do
        subject.dimension = { 'h' => 10.2, 'w' => 10.2, 'd' => 10.1 }
        should be_valid
      end
      it 'invalid' do
        subject.dimension = { 'h' => 10.2, 'w' => 10.2, 'zdsfsdf' => 10.1 }
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
      subject.create_inventory(count: 100)
      expect(subject.in_stock?).to be_truthy
    end
    it 'true' do
      subject.create_inventory(count: 0)
      expect(subject.in_stock?).to be_falsey
    end
  end
end
