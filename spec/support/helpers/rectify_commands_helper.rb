module Support
  module Command
    class MockCommand < Rectify::Command
      class << self
        attr_accessor :block_value
      end

      def initialize(*attributes)
      end
    end

    class Valid < MockCommand
      def call
        broadcast :valid, self.class.block_value
      end
    end

    class Invalid < MockCommand
      def call
        broadcast :invalid, self.class.block_value
      end
    end
  end
end
