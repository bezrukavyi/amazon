require 'rails_helper'

RSpec.describe SpecSymbolsValidator, type: :validator do

  let(:review) { ReviewForm.from_params attributes_for(:review) }

  context 'valid' do
    after do
      review.validate(:title)
      expect(review.errors.full_messages).to be_blank
    end

    it 'middle symbol' do
      review.title = 'yaros.lav'
    end
    it 'end symbol' do
      review.title = 'yaroslav!'
    end
  end

  context 'invalid' do
    after do
      review.validate(:title)
      expect(review.errors.full_messages)
      .to include('Title ' + I18n.t('validators.spec_symbols.base_regexp'))
    end

    it 'with twice successive dot' do
      review.title = 'yar..oslav'
    end
    it 'with twice dot' do
      review.title = 'yar.osl.av'
    end
    it 'started with symbol' do
      review.title = '!yaroslav'
    end

  end

end
