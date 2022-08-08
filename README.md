# Warehouse::Item

```ruby
@item1 = Warehouse::Item::Code.new('迷黑', '迷黑', 3, 250)
```

# Warehouse::Random

```ruby
@item1 = Warehouse::Item::Code.new('迷黑', '迷黑', nil, 250)
@item2 = Warehouse::Item::Code.new('迷黃', '迷黃', nil, 250)
@item3 = Warehouse::Item::Code.new('迷綠', '迷綠', nil, 250)
@random_item = Warehouse::Item::Random.new([@item1, @item2, @item3], 4)
@list = @random_item.fetch! # (Warehouse::List)
```

# Warehouse::List

```ruby
@item1 = Warehouse::Item::Code.new('迷黑', '迷黑', 1, 250)
@item2 = Warehouse::Item::Code.new('迷黃', '迷黃', 1, 250)
@item3 = Warehouse::Item::Code.new('迷綠', '迷綠', 1, 250)
@list = Warehouse::List.new([@item1, @item2, @item3])

# 所有數量變兩倍 (會解壓縮 RandomItem)
@list *= 2

# 迷黑數量 + 1
@list += @item1

# 解壓 random item (回傳都是已經隨機好的品項)
@list = @random_item.items!

# 回傳 item
@list.find('迷黑') 
```
