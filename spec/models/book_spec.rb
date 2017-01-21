require 'rails_helper'

RSpec.describe Book, type: :model do

  subject { create(:book) }

  context 'validation' do
    it 'when validate' do
      expect(subject).to be_valid
    end
    it 'invalid dimension' do
      subject.dimension = { "h": 10.2,"w": 10.2,"zdsfsdf": 10.1 }
      expect(subject).not_to be_valid
    end
    it 'invalid price' do
      subject.price = 0
      expect(subject).not_to be_valid
    end
    it 'invalid count' do
      subject.count = -1
      expect(subject).not_to be_valid
    end
  end

  context 'association' do
    it 'HABM authors' do
      expect(subject).to have_and_belong_to_many(:authors)
    end
    it 'HABM materials' do
      expect(subject).to have_and_belong_to_many(:materials)
    end
    it 'belong to category' do
      expect(subject).to belong_to(:category)
    end
    it 'has many pictures' do
      expect(subject).to have_many(:pictures)
    end
  end

  context 'Scopes' do
    describe '#with_category' do
      let(:fantasy) { create :category }
      let(:drama) { create :category }

      before do
        create :book, category: fantasy
        create :book, category: fantasy
        create :book, category: fantasy
        create :book, category: drama
      end

      it '#with fantasy' do
        expect(Book.with_category(fantasy.title).count).to eq(3)
      end
    end

    describe '#sorted_by' do
      before do
        @harry_potter = create(:book, price: 2.0, title: 'A title')
        @ruby_way = create(:book, price: 3.0, title: 'D title')
        @rails_way = create(:book, price: 1.0, title: 'C title')
        @book = create(:book, price: 4.0, title: 'B title')
      end

      it '#asc_title' do
        answer = [@harry_potter, @book, @rails_way, @ruby_way]
        expect(Book.sorted_by(:asc_title)).to eq(answer)
      end

      it '#desc_title' do
        answer = [@ruby_way, @rails_way, @book, @harry_potter]
        expect(Book.sorted_by(:desc_title)).to eq(answer)
      end

      it '#newest' do
        answer = [@book, @rails_way, @ruby_way, @harry_potter]
        expect(Book.sorted_by(:newest)).to eq(answer)
      end

      it '#low_price' do
        answer = [@rails_way, @harry_potter, @ruby_way, @book]
        expect(Book.sorted_by(:low_price)).to eq(answer)
      end

      it '#hight_price' do
        answer = [@book, @ruby_way, @harry_potter, @rails_way]
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

end
