feature 'Payment step', type: :feature do
  let(:user) { create :user }
  let(:order) { create :order, :checkout_package, user: user }

  background do
    allow_any_instance_of(CheckoutsController)
      .to receive(:current_order).and_return(order)
    login_as(user, scope: :user)
  end

  scenario "When user don't choose delivery" do
    order.delivery = nil
    visit checkout_path(id: :payment)
    expect(current_path).to eq(checkout_path(id: :delivery))
    expect(page).to have_content(I18n.t('flash.failure.step'))
  end

  scenario "When user don't fill credit_card" do
    order.update_attribute(:credit_card, nil)
    visit checkout_path(id: :payment)
    click_button I18n.t('simple_form.titles.save_and_continue')
    expect(page).to have_content(I18n.t('errors.messages.blank'))
  end
end
