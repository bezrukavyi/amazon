class UpdateAddress < Checkout::StepAddress
  def initialize(options)
    @addressable = options[:addressable]
    @addresses = [address_by_params(options[:params][:address])]
  end
end
