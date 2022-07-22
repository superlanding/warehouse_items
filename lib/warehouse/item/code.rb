module Warehouse
  module Item
    Code = Struct.new(:code, :title, :qty, :price, :barcode, :code_2, :title_en) do

      def is_free?
        price == 0
      end

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
          'qty' => qty,
          'price' => price,
          'barcode' => barcode,
          'code_2' => code_2,
          'title_en' => title_en
        }
      end

      def deep_dup
        self.class.new(code, title, qty, price, barcode, code_2, title_en)
      end

      # 給 form 用的
      def persisted?; false end
      def product; end
    end
  end
end
