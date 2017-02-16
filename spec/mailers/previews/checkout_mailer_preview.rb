# Preview all emails at http://localhost:3000/rails/mailers/checkout_mailer
class CheckoutMailerPreview < ActionMailer::Preview
  def complete
    CheckoutMailer.complete(User.first, Order.last)
  end
end
