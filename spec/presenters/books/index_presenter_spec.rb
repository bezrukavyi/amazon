describe Books::IndexPresenter do
  before do
    @category = create :category
    @book = create :book, category: @category
    @user = create :user
    @params = { sorted_by: 'asc_title', page: 2 }
  end

  subject { Books::IndexPresenter.new(@params, @category) }

  it '#sort_types' do
    expect(subject.sort_types).to eq(Book::SORT_TYPES)
  end

  it '#book_count' do
    allow(Book).to receive(:count).and_return(100)
    expect(subject.book_count).to eq(100)
  end

  context '#books' do
    before do
      expect(Book).to receive(:sorted_by).with(@params[:sorted_by])
        .and_return(Book)
      expect(Book).to receive(:page).with(@params[:page]).and_return(Book)
      expect(Book).to receive(:with_authors).and_return(Book)
    end
    it 'without category' do
      allow(subject).to receive(:category).and_return(nil)
      expect(Book).not_to receive(:where)
      subject.books
    end
    it 'with category' do
      allow(subject).to receive(:category).and_return(@category)
      expect(Book).to receive(:where).with(category: @category)
      subject.books
    end
  end
end
