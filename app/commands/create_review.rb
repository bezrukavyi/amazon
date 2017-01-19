class CreateReview < Rectify::Command

  attr_reader :review_form

  def initialize(review_form)
    @review_form = review_form
  end

  def call
    if review_form.valid? && Review.create(review_form.to_h)
      broadcast :valid
    else
      broadcast :invalid
    end
  end

end
