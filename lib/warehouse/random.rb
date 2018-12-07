class Warehouse::Random < Struct.new(:items, :qty)

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
      random_items[item.code] = Warehouse::Item.new(item.code, item.title, 0, item.price)
      random_items[item.code].qty += 1
    end
    Warehouse::List.new(random_items.values)
  end

  def persisted?; end

  def deep_dup
    Warehouse::Random.new(items.map { |item| item.deep_dup }, qty)
  end
end
