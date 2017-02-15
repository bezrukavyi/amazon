FactoryGirl.define do
  factory :picture do
    path do
      path = File.join(Rails.root, 'spec/fixtures/books/test_picture.jpg')
      Rack::Test::UploadedFile.new(path)
    end
    association :imageable, factory: :book
  end
end
