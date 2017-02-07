class CreateReview < Rectify::Command

  attr_reader :user, :review_form

  def initialize(user, review_form)
    @user = user
    @review_form = review_form
  end

  def call
    if review_form.valid? && create_review
      broadcast :valid
    else
      broadcast :invalid
    end
  end

  private

  def create_review
    review_params = review_form.to_h
    review_params[:verified] = user.bought_book?(review_params[:book_id])
    Review.create(review_params)
  end

end
