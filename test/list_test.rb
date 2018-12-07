require "test_helper"

describe "Warehouse::List" do
  include RandomHelper

  should "#none" do
    @list = Warehouse::List.none
    assert_equal true, @list.empty?
  end

  should "#empty?" do
    @list = Warehouse::List.new([Warehouse::Item.new])
    assert_equal false, @list.empty?
  end

  should "#new assign nil" do
    @list = Warehouse::List.new
    assert_equal [], @list.items
  end

  context "*" do
    setup do
      @item1 = Warehouse::Item.new("黑", "黑", 1)
      @item2 = Warehouse::Item.new("白", "白", 1)
      @list = Warehouse::List.new([@item1, @item2])
      @new_list = @list * 2
    end

    should "@list.object_id != @new_list.object_id" do
      assert @list.object_id != @new_list.object_id
    end

    context "@list" do
      should "[0] = 黑*1" do
        assert_equal '黑', @list[0].code
        assert_equal 1, @list[0].qty
      end

      should "[1] = 白*2" do
        assert_equal '白', @list[1].code
        assert_equal 1, @list[1].qty
      end
    end

    context "@new_list" do
      should "[0] = 黑*2" do
        assert_equal '黑', @new_list[0].code
        assert_equal 2, @new_list[0].qty
      end

      should "[1] = 白*2" do
        assert_equal '白', @new_list[1].code
        assert_equal 2, @new_list[1].qty
      end
    end
  end

  context "#find" do
    setup do
      @item1 = Warehouse::Item.new("黑", "黑", 1)
      @item2 = Warehouse::Item.new("白", "白", 1)
      @list = Warehouse::List.new([@item1, @item2])
    end

    should "@item1.object_id = @list.find('黑')" do
      assert_equal @item1.object_id, @list.find('黑').object_id
    end

    should "@item1.code = @list.find('黑').code" do
      assert_equal @item1.code, @list.find('黑').code
    end
  end

  context "+ Warehouse::Item" do
    setup do
      @list = Warehouse::List.new
      @item1 = Warehouse::Item.new("黑", "黑", 1)
      @item2 = Warehouse::Item.new("白", "白", 1)
      @new_list_1 = @list + @item1
      @new_list_2 = @new_list_1 + @item2
      @new_list_3 = @new_list_2 + @item2
    end

    should "@list.object_id != @new_list_1.object_id != @new_list_2.object_id" do
      assert @list.object_id != @new_list_1.object_id
      assert @new_list_1.object_id != @new_list_2.object_id
    end

    should "@list.items.length = 0" do
      assert_equal 0, @list.items.length
    end

    should "@new_list_1.items.length = 1" do
      assert_equal 1, @new_list_1.items.length
    end

    should "@new_list_2.items.length = 2" do
      assert_equal 2, @new_list_2.items.length
    end

    should "@new_list_3.items.length = 2" do
      assert_equal 2, @new_list_2.items.length
    end

    should "@new_list_2.find('白').qty = 1" do
      assert_equal 1, @new_list_2.find('白').qty
    end

    should "@new_list_3.find('白').qty = 2" do
      assert_equal 2, @new_list_3.find('白').qty
    end

    should "@new_list_1.find('黑').object_id != @new_list_2.find('黑').object_id" do
      assert_equal true, @new_list_1.find('黑').object_id != @new_list_2.find('黑').object_id
    end
  end

  context "+ Warehouse::List" do
    setup do
      @item1 = Warehouse::Item.new("黑", "黑", 2)
      @item2 = Warehouse::Item.new("白", "白", 3)
      @list1 = Warehouse::List.new([@item1, @item2])
      @item3 = Warehouse::Item.new("黑", "黑", 4)
      @item4 = Warehouse::Item.new("白", "白", 5)
      @list2 = Warehouse::List.new([@item3, @item4])
      @list3 = @list1 + @list2
    end

    should "@list1.object_id != @list2.object_id != @list3.object_id" do
      assert @list1.object_id != @list2.object_id
      assert @list2.object_id != @list3.object_id
    end

    should "@list3.items.length = 2" do
      assert_equal 2, @list3.items.length
    end

    should "@list3.items[0] = 黑*6" do
      assert_equal '黑', @list3.items[0].code
      assert_equal 6, @list3.items[0].qty
    end

    should "@list3.items[1] = 白*8" do
      assert_equal '白', @list3.items[1].code
      assert_equal 8, @list3.items[1].qty
    end
  end
end
