FactoryGirl.define do
  factory :picture do
    path { Rack::Test::UploadedFile.new(File.join(Rails.root,
      'spec/fixtures/books/test_picture.jpg')) }
  end
end
