describe ReviewForm, :review_form do
  subject { ReviewForm.from_params attributes_for(:review) }

  context 'validation' do
    [:grade, :book_id, :user_id, :title].each do |name|
      it { should validate_presence_of(name) }
    end
  end
end
