module Warehouse
  module Item
    Barcode = Struct.new(:barcode, :title, :qty) do

      def barcode?
        true
      end

      def code?
        false
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
          'barcode' => barcode,
          'title' => title,
          'qty' => qty
        }
      end

      def deep_dup
        self.class.new(barcode, title, qty)
      end

      # 給 form 用的
      def persisted?; false end
      def product; end
    end
  end
end
