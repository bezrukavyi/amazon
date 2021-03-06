module Checkout
  class StepConfirm < Rectify::Command
    attr_reader :order, :user, :confirm

    def initialize(options)
      @order = options[:order]
      @user = options[:user]
      @confirm = options[:params][:confirm] if options[:params]
    end

    def call
      return broadcast(:invalid) if confirm.blank? || user.blank?
      transaction do
        order.confirm!
        send_mail
      end
      broadcast :valid
    end

    private

    def send_mail
      CheckoutMailer.complete(user, order).deliver
    end
  end
end
