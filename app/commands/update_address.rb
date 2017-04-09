class UpdateAddress < Checkout::StepAddress
  def initialize(options)
    @addressable = options[:addressable]
    @params = options[:params]
    @addresses = [address_by_params(params[:address])]
  end
end
