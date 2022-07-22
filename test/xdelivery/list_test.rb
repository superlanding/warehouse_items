require 'test_helper'

describe "Xdelivery::Warehouse::List" do
  describe '當傳入 "Warehouse::Item 陣列" 時...' do
    before do
      @item_1 = Warehouse::Item::Code.new('迷黑', '迷黑', 2)
      @item_2 = Warehouse::Item::Barcode.new('TC1234', 'TC1234', 3)
      @items = [ @item_1, @item_2 ]
      @list = Warehouse::List.new(@items)
    end

    should '#to_a' do
      expected = [
        { "code" => '迷黑', 'title' => "迷黑", "qty" => 2 },
        { "barcode" => 'TC1234', 'title' => "TC1234", "qty" => 3 }
      ]
      expected = [
        { "code" => "迷黑", "title" => "迷黑", "qty" => 2, "price" => nil,
          "barcode" => nil, "code_2" => nil, "title_en" => nil },
        { "barcode" => "TC1234", "title" => "TC1234", "qty" => 3}
      ]
      assert_equal(expected, @list.to_a)
    end

    should '#to_h' do
      expected = { "迷黑" => 2, "TC1234" => 3 }
      assert_equal expected, @list.to_h
    end

    describe '#find' do
      should '查找 "迷黑" 應該回傳 @item' do
        assert_equal @item_1, @list.find("迷黑")
      end

      should '查找 "FX1234" 應該回傳 nil' do
        assert_nil @list.find("FX1234")
      end
    end

    describe '#+ 加上(迷黑, 3)' do
      before do
        @result_list = @list + Warehouse::Item::Code.new('迷黑', '迷黑', 3)
      end

      should '迷黑 = 5 ' do
        assert_equal 5, @result_list.find("迷黑").qty
      end

      should 'TC1234 = 3 (不變)' do
        assert_equal 3, @result_list.find("TC1234").qty
      end

      should '原本 @list 不改變 (迷黑 = 2)' do
        assert_equal 2, @list.find("迷黑").qty
      end
    end

    describe '+= (迷黑x2)' do
      before do
        @list += Warehouse::Item::Code.new('迷黑', '迷黑', 3)
      end

      should '迷黑 = 5' do
        assert_equal 5, @list.find("迷黑").qty
      end

      should '#length = 2' do
        assert_equal 2, @list.length
      end
    end

  end

  describe '當傳入 "空陣列" ' do
    before do
      @list = Warehouse::List.new
    end

    should '#empty = true' do
      assert_equal(true, @list.empty?)
    end

    should '#to_a' do
      assert_empty @list.to_a
    end

    should '#to_h' do
      assert_empty @list.to_h
    end

    describe '#+= 加等於(迷黑, 3)' do
      before do
        @list += Warehouse::Item::Code.new('迷黑', '迷黑', 3)
      end

      should '迷黑 = 3 ' do
        assert_equal 3, @list.find("迷黑").qty
      end
    end
  end

  # 因為 Random 有可能要 qty = nil
  # TODO: 蓓姬塔要檢查是否允許這樣做
  # ----------------------------
  # describe '當 #+ 傳入參數錯誤時...' do
  #   should '+ 1， 丟出錯誤 RuntimeError' do
  #     assert_raise(RuntimeError) { Warehouse::List.new + 1 }
  #   end

  #   should '+ (迷黑, "2")，丟出錯誤 Warehouse::Item::ArgumentError' do
  #     @items = [ Warehouse::Item::Code.new('迷黑', '迷黑', '3') ]
  #     @list = Warehouse::List.new(@items)

  #     assert_raise(Warehouse::Item::ArgumentError) {
  #       @list + Warehouse::Item::Code.new('迷黑', '迷黑', '3')
  #     }
  #   end
  # end
end
