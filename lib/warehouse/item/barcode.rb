module Warehouse
  module Item
    class Barcode < Base
      def initialize(*)
        super
        self.code_type = :barcode
      end

      def barcode
        code_or_barcode
      end

      def code
        raise NoMethodError, "use #barcode instead."
      end

      def to_h
        {
          'barcode' => code_or_barcode,
          'title' => title,
          'qty' => qty
        }
      end
    end
  end
end
