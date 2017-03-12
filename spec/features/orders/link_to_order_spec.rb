# include Support::Order
# include Support::CheckAttributes
#
# feature 'Link to order', type: :feature, js: true do
#   let(:user) { create :user }
#
#   background do
#     @order = create(:order, :checkout_package, state: :delivered, user: user)
#   end
#
#   scenario 'User want go to order from orders page' do
#     login_as(user, scope: :user)
#     visit orders_path
#     find('.table-link', text: @order.id).click
#     expect(current_path).to eq(order_path(id: @order))
#   end
# end
