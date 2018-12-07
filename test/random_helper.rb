module RandomHelper
  def stub_random_warehouse_items(*items)
    list = Warehouse::List.new(items.map { |i| Warehouse::Item.new(i, i, 1, 0) })
    Warehouse::Random.stub_any_instance(:fetch!, list) do
      yield
    end
  end
end