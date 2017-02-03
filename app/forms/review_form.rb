class ReviewForm < Rectify::Form

  STRING_ATTRS = [:title, :desc]
  INTEGER_ATTRS = [:grade, :book_id, :user_id]

  STRING_ATTRS.each { |name| attribute name, String }

  INTEGER_ATTRS.each do |name|
    attribute name, Integer
    validates name, presence: true
  end

  validates :title, :desc, spec_symbols: true, presence: true
  validates :title, length: { maximum: 80 }
  validates :desc, length: { maximum: 500 }
  validates :grade, numericality: { greater_than_or_equal_to: 1,
    less_than_or_equal_to: 5 }
end
