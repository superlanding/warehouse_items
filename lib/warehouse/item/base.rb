module Warehouse
  module Item
    Base = Struct.new(:code_or_barcode, :title, :qty, :price) do
      attr_accessor :code_type
      attr_accessor :items

      def barcode?
        code_type == :barcode
      end

      def code?
        code_type == :code
      end

      def type
        'single'
      end

      def random?
        false
      end

      def single?
        true
      end

      def deep_dup
        self.class.new(code_or_barcode, title, qty, price)
      end

      # 給 form 用的
      def persisted?; false end
      def product; end
    end
  end
end
