class Warehouse::List
  attr_accessor :items

  delegate :empty?, to: :items
  delegate :length, to: :items
  delegate :present?, to: :items
  delegate :any?, to: :items
  delegate :all?, to: :items
  delegate :each, to: :items
  delegate :each_with_index, to: :items
  delegate :map, to: :items
  delegate :[], to: :items
  delegate :to_json, to: :items

  class << self
    def none
      new
    end
  end

  def initialize(items=nil)
    self.items = (items || [])
  end

  # 找到此清單底下料號 (同樣 object_id)
  def find(code, type: nil)
    case type
    when :code
      items.detect { |item| item.code? && item.code == code }
    when :barcode
      items.detect { |item| item.barcode? && item.barcode == code }
    else
      items.detect do |item|
        (item.code? && item.code == code) || (item.barcode? && item.barcode == code)
      end
    end
  end

  # 解開隨機料號 (New List)
  def items!
    list = Warehouse::List.new
    items.each do |item|
      extra_items = item.is_a?(Warehouse::Item::Random) ? item.fetch! : [ item ]

      extra_items.each do |item|
        list.items << item
      end
    end
    list
  end

  # 把料號加入到清單內 (Clone List)
  def +(item)
    case item
    when Warehouse::Item::Code, Warehouse::Item::Barcode
      add_item(item)
    when Warehouse::Item::Random
      # 隨機抽一個
      add_item(item.fetch!)
    when Warehouse::List
      list = deep_dup
      item.each do |target|
        list += target
      end
      list
    end
  end

  # 把料號 * 數量 (Clone List)
  def *(qty)
    Warehouse::List.new.tap do |list|
      items!.each do |item|
        list.items << item.deep_dup.tap { |i| i.qty = i.qty * qty }
      end
    end
  end

  def deep_dup
    Warehouse::List.new(items.map { |item| item.deep_dup })
  end

  def to_h
    items.map do |item|
      [
        (item.code? ? item.code : item.barcode),
        item.qty
      ]
    end.to_h
  end

  def to_a
    items.map(&:to_h)
  end

  protected

  def add_item(item)
    list = deep_dup
    # 找到 barcode or code item
    target = if item.code?
      list.find(item.code, type: :code)
    else
      list.find(item.barcode, type: :barcode)
    end

    if target.present?
      target.qty = (target.qty + item.qty)
    else
      list.items << item.deep_dup
    end
    list
  end
end
