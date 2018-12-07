class Warehouse::Item < Struct.new(:code, :title, :qty, :price)
  attr_accessor :items

  def type
    'single'
  end

  def random?
    false
  end

  def single?
    true
  end

  def persisted?; end

  def deep_dup
    Warehouse::Item.new(code, title, qty, price) 
  end
end