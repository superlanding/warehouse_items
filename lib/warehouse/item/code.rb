module Warehouse
  module Item
    Code = Struct.new(:code, :title, :qty, :price) do

      def barcode?
        false
      end

      def code?
        true
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

      def to_h
        {
          'code' => code,
          'title' => title,
          'qty' => qty
        }
      end

      def deep_dup
        self.class.new(code, title, qty, price)
      end

      # 給 form 用的
      def persisted?; false end
      def product; end
    end
  end
end
