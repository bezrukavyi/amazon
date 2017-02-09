describe CheckoutMailer, type: :mailer do

  describe '#complete' do
    let(:user) { create :user }
    let(:order) { create :order, user: user }
    let(:order_item) { create :order_item, order: order }
    let(:mail) { described_class.complete(user, order).deliver_now }

    it 'renders the subject' do
      expect(mail.subject).to eq("Complete Order ##{order.id}")
    end

    it 'renders the receiver email' do
      expect(mail.to).to eq([user.email])
    end

    it 'renders the sender email' do
      expect(mail.from).to eq(['rspecyaroslav@gmail.com'])
    end

    it 'assigns @name' do
      expect(mail.body.encoded).to match(user.decorate.full_name)
    end

    it 'assigns @order' do
      expect(mail.body.encoded).to match("Order ##{order.id}")
    end

  end
end
