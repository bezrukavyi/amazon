class MainPagesController < ApplicationController

  def index
    @carousel_books = Book.includes(:authors).order('RANDOM()').limit(4)
    @best_sellers = Book.includes(:authors).best_sellers
  end

end
