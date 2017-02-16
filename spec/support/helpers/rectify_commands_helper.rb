module Support
  module Command
    def self.const_missing(name)
      new_class = Class.new(Rectify::Command) do
        class << self
          attr_accessor :block_value
        end
        def initialize(*attributes); end

        def call
          broadcast broadcast_name, self.class.block_value
        end

        def broadcast_name
          self.class.name.split('::').last.underscore.to_sym
        end
      end

      const_set(name.to_s, new_class)
    end
  end
end
