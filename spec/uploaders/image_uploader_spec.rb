require 'rails_helper'

RSpec.describe ImageUploader do

  let(:file) { fixture_file_upload('/books/test_picture.jpg') }
  let(:picture) { create :picture }
  let(:uploader) { ImageUploader.new(picture, :avatar) }

  before do
    ImageUploader.enable_processing = true
    File.open(file) { |f| uploader.store!(f) }
  end

  after do
    ImageUploader.enable_processing = false
    uploader.remove!
  end

  context 'the thumb version' do
    it "scales down a landscape image to be exactly 400 by 300 pixels" do
      expect(uploader.thumb).to have_dimensions(400, 300)
    end
  end

  context 'the small version' do
    it "scales down a landscape image to fit within 100 by 200 pixels" do
      expect(uploader.small).to be_no_larger_than(200, 150)
    end
  end

end
