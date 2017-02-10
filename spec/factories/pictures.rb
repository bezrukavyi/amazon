FactoryGirl.define do
  factory :picture do
    path do
      Rack::Test::UploadedFile.new(
        File.join(Rails.root, 'spec/fixtures/books/test_picture.jpg')
      )
    end
    association :imageable, factory: :book
  end
end
