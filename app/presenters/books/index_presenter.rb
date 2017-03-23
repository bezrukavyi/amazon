module Books
  class IndexPresenter
    attr_reader :params, :category

    def initialize(params, category = nil)
      @params = params
      @category = category
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
      books = Book.select(:id, :price, :title, :avatar)
                  .includes(:inventory)
                  .sorted_by(params[:sorted_by])
                  .page(params[:page]).with_authors
      category.present? ? books.where(category: category) : books
    end
  end
end
