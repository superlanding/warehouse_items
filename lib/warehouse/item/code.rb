module Warehouse
  module Item
    class Code < Base
      def initialize(*)
        super
        self.code_type = :code
      end

      def code
        code_or_barcode
      end

      def to_h
        {
          'code' => code_or_barcode,
          'title' => title,
          'qty' => qty
        }
      end
    end
  end
end
