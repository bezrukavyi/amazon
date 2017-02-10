class Books::IndexPresenter
  attr_reader :params, :category

  def initialize(options)
    @params = options[:params]
    @category = options[:category]
  end

  def sort_types
    @sort_types ||= Book::SORT_TYPES
  end

  def book_count
    @book_count ||= Book.count
  end

  def books
    @books ||= set_books
  end

  private

  def set_books
    books = Book.sorted_by(params[:sorted_by]).page(params[:page]).with_authors
    books = books.where(category: category) if category.present?
    books
  end
end
