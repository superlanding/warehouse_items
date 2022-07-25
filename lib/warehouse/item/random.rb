module Warehouse
  module Item
    Random = Struct.new(:items, :qty) do
      attr_accessor :code, :title, :price

      def type
        'random'
      end

      def random?
        true
      end

      def single?
        false
      end

      def fetch
        @fetch ||= fetch!
      end

      def fetch!
        random_items = {}
        (1..qty).each do
          item = items.sample
          random_items[item.code] ||= Warehouse::Item::Code.new(item.code, item.title, 0, item.price,
                                                                item.barcode, item.code_2, item.title_en)
          random_items[item.code].qty += 1
        end
        Warehouse::List.new(random_items.values)
      end

      def persisted?; end

      def deep_dup
        Warehouse::Item::Random.new(items.map { |item| item.deep_dup }, qty)
      end
    end
  end
end
