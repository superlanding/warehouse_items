require "test_helper"

describe "Warehouse::Random" do
  before do
    @item1 = Warehouse::Item.new('迷黑', '迷黑', nil, 250)
    @item2 = Warehouse::Item.new('迷黃', '迷黃', nil, 250)
    @item3 = Warehouse::Item.new('迷綠', '迷綠', nil, 250)
    @random_item = Warehouse::Random.new([@item1, @item2, @item3], 4)
    @list = @random_item.fetch!
  end

  should "#fetch! is Warehouse::List" do
    assert_equal true, @list.is_a?(Warehouse::List)
  end

  (1..10).each do |i|
    should "@list 總數量 = 4 (#{i})" do
      assert_equal 4, @list.items.inject(0){ |sum, item| sum + item.qty }
    end

    should "@list 品項符合 #items (#{i})" do
      @list.items.each do |item|
        assert_includes ['迷黑', '迷黃', '迷綠'], item.code
        assert_includes ['迷黑', '迷黃', '迷綠'], item.title
        assert_equal 250, item.price
      end
    end
  end
end
