module Warehouse
  module Item
    Code = Struct.new(:barcode, :code, :code_2, :title, :title_en, :qty, :price) do

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
          'barcode' => barcode,
          'code' => code,
          'code_2' => code_2,
          'title' => title,
          'title_en' => title_en,
          'qty' => qty,
          'price' => price
        }
      end

      def deep_dup
        self.class.new(barcode, code, code_2, title, title_en, qty, price)
      end

      # 給 form 用的
      def persisted?; false end
      def product; end
    end
  end
end
