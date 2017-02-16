feature 'Delivery step', type: :feature do
  let(:user) { create :user }
  let(:order) { create :order, :checkout_package, user: user }

  background do
    allow_any_instance_of(CheckoutsController)
      .to receive(:current_order).and_return(order)
    login_as(user, scope: :user)
  end

  scenario "When user don't choose address" do
    order.shipping = nil
    visit checkout_path(id: :delivery)
    expect(current_path).to eq(checkout_path(id: :address))
    expect(page).to have_content(I18n.t('flash.failure.step'))
  end

  scenario "When user don't fill delivery" do
    order.update_attribute(:delivery, nil)
    visit checkout_path(id: :delivery)
    click_button I18n.t('simple_form.titles.save_and_continue')
    expect(current_path).to eq(checkout_path(id: :delivery))
  end
end
