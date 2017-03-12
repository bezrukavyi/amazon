# include Support::Order
#
# feature 'Show Order', type: :feature do
#   let(:user) { create :user }
#   let(:order) do
#     create(:order, :checkout_package, state: :processing, user: user).decorate
#   end
#
#   background do
#     login_as(user, scope: :user)
#     visit order_path(I18n.locale, order.id)
#   end
#
#   scenario 'User on page order' do
#     check_order_info(order)
#   end
# end
