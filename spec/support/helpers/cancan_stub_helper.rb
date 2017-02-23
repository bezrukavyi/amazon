module Support
  module CanCanStub
    def receive_cancan(name, varibles = {})
      allow_any_instance_of(CanCan::ControllerResource).to receive(:"#{name}_resource") { nil }
      varibles.each do |name, value|
        controller.instance_variable_set("@#{name}", value)
      end
    end
  end
end
