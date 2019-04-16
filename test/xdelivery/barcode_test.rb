require 'test_helper'

describe "Xdelivery::Warehouse::Item::BarcodeTest" do

  describe '當傳入值 “全部正確” 時...' do
    before do
      @item = Warehouse::Item::Barcode.new('TC1234', 'TC1234', 2)
    end

    should '#barcode = "TC1234" ' do
      assert_equal 'TC1234', @item.barcode
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

    should '#to_h = { "barcode" => "TC1234", "title" => "TC1234", "qty" => 2 }' do
      expted = { "barcode" => "TC1234", "title" => "TC1234", "qty" => 2 }
      assert_equal expted, @item.to_h
    end

    describe '#deep_dup' do
      before do
        @dup = @item.deep_dup
      end

      should '類型等於 Warehouse::Item::Barcode' do
        assert_instance_of Warehouse::Item::Barcode, @dup
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
