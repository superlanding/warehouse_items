require 'test_helper'

describe "Xdelivery::Warehouse::Item::CodeTest" do

  describe '當傳入值 “全部正確” 時...' do
    before do
      @item = Warehouse::Item::Code.new('迷黑', '迷黑', 2)
    end

    should '#code = "迷黑" ' do
      assert_equal '迷黑', @item.code
    end

    should '#qty = 2 ' do
      assert_equal 2, @item.qty
    end

    should '#persisted? = false' do
      assert_equal false, @item.persisted?
    end

    should '#product = nil' do
      assert_nil(@item.product)
    end

    should '#to_h = {"barcode"=>nil, "code"=>"迷黑", "code_2"=>nil, "title"=>"迷黑", "title_en"=>nil, "qty"=>2, "price"=>nil}' do
      expted = { "barcode" => nil, "code" => "迷黑", "code_2" => nil, "title" => "迷黑",
                 "title_en" => nil, "qty" => 2, "price" => nil }
      assert_equal expted, @item.to_h
    end

    describe '#deep_dup' do
      before do
        @dup = @item.deep_dup
      end

      should '類型等於 Warehouse::Item::Code' do
        assert_instance_of(Warehouse::Item::Code, @dup)
      end

      should '等於 @item' do
        assert_equal @item, @dup
      end

      should "object_id 不同" do
        assert @item.object_id != @dup.object_id
      end

      should 'qty + 1 後，原本的 @item.qty 不變' do
        @dup.qty += 1
        assert_equal 3, @dup.qty
        assert_equal 2, @item.qty
      end
    end
  end
end
