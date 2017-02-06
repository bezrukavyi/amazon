require 'rails_helper'

RSpec.describe HumanNameValidator, type: :validator do

  with_model :MockUser do
    table do |t|
      t.string :name
      t.string :names
    end

    model do
      validates :name, human_name: :one
      validates :names, human_name: :few
    end
  end

  describe '#one' do
    let(:user) { MockUser.new(name: 'Name') }

    it 'valid' do
      user.validate(:name)
      expect(user.errors.full_messages).to be_blank
    end

    context 'invalid' do
      after do
        user.validate(:name)
        expect(user.errors.full_messages)
          .to include('Name ' + I18n.t('validators.human.name.base_regexp'))
      end

      it 'without end numeric' do
        user.name = 'yaroslav5'
      end
      it 'with spec sumbols' do
        user.name = 'yarosl%av'
      end
      it 'with space' do
        user.name = 'yaro slav'
      end
    end
  end

  describe '#few' do
    let(:user) { MockUser.new(names: 'Name names') }

    it 'valid' do
      user.names = 'Yaroslav Bezr'
      user.validate(:names)
      expect(user.errors.full_messages).to be_blank
    end

    context 'invalid' do
      after do
        user.validate(:names)
        expect(user.errors.full_messages)
          .to include('Names ' + I18n.t('validators.human.name.base_regexp'))
      end

      it 'with spec sumbols' do
        user.names = 'yaroslav#fdasfd'
      end
      it 'with numeric' do
        user.names = 'yaro323'
      end
    end
  end

end
