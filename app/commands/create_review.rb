class CreateReview < Rectify::Command
  attr_reader :user, :book, :params

  def initialize(options)
    @user = options[:user]
    @book = options[:book]
    @params = options[:params]
  end

  def call
    if review_form.valid? && create_review
      broadcast :valid, book
    else
      broadcast :invalid, review_form
    end
  end

  private

  def review_form
    @review_form ||= ReviewForm.from_params(review_params)
  end

  def review_params
    params[:review].merge(user_id: user.id, book_id: @book.id)
  end

  def create_review
    review_params = review_form.to_h
    review_params[:verified] = user.bought_product?(@book)
    Review.create(review_params)
  end
end
