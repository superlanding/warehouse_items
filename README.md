# warehouse_items

[![Gem Version](https://badge.fury.io/rb/warehouse_items.svg)](https://rubygems.org/gems/warehouse_items)
[![Tests](https://github.com/superlanding/warehouse_items/actions/workflows/test.yml/badge.svg)](https://github.com/superlanding/warehouse_items/actions/workflows/test.yml)

倉儲「品項」的 value object 與清單（`Warehouse::Item::Code` / `Warehouse::Item::Barcode` / `Warehouse::Item::Random` / `Warehouse::List`），
用來表示出貨明細：料號與數量、以條碼表示的品項、**隨機（福袋）品項**，以及可以相加、相乘、展開隨機品項的清單。

這個 gem 不依賴資料庫，只依賴 `activesupport`，在 Rails 專案或一般 Ruby 程式都能用。
`super_tools` 等其他自家 gem 也會依賴它。

## 需求

| | 支援版本（CI 矩陣） |
|---|---|
| Ruby | 3.0、3.1、3.2、3.3、3.4（gemspec：`>= 2.7`） |
| Rails / ActiveSupport | 7.0、7.1、7.2、8.0、8.1 |

CI 會跑所有 Ruby 可用的組合（Rails 7.2 需要 Ruby >= 3.1；Rails 8.0 / 8.1 需要 Ruby >= 3.2），
詳見 [`.github/workflows/test.yml`](.github/workflows/test.yml)。

## 安裝

gem 名稱是 `warehouse_items`，但 require 的檔名是 `warehouse`（`lib/warehouse.rb`），所以 Gemfile 要指定 `require: "warehouse"`，
否則 Bundler 不會自動載入（只會載入 `Warehouse::VERSION`）：

```ruby
# Gemfile
gem "warehouse_items", require: "warehouse"
```

```bash
bundle install
```

不用 Bundler 時：`gem install warehouse_items`，然後 `require "warehouse"`。

## 用法

### 品項：`Warehouse::Item::Code`

以料號（code）表示的品項，是 `Struct`，欄位依序為 `code, title, qty, price, barcode, code_2, title_en`。

```ruby
black  = Warehouse::Item::Code.new("BLACK", "迷黑", 3, 250)
yellow = Warehouse::Item::Code.new("YELLOW", "迷黃", 1, 250, "4710000000001", "Y-2", "Yellow")

black.to_h
#=> { "code" => "BLACK", "title" => "迷黑", "qty" => 3, "price" => 250,
#     "barcode" => nil, "code_2" => nil, "title_en" => nil }

black.is_free?                                          #=> false（price == 0 才是 true）
black.type                                              #=> "single"
black.code?                                             #=> true
black.barcode?                                          #=> false

# 由字串 key 的 hash 建立（例如 JSON / DB 讀出來的資料）；qty 缺省為 0，qty / price 會轉成整數
Warehouse::Item::Code.build("code" => "X", "title" => "T", "qty" => "3", "price" => "10")
#=> #<struct Warehouse::Item::Code code="X", title="T", qty=3, price=10, ...>
```

### 品項：`Warehouse::Item::Barcode`

以條碼表示的品項：`Warehouse::Item::Barcode.new(barcode, title, qty)`。

```ruby
bar = Warehouse::Item::Barcode.new("4710000000002", "條碼品項", 2)
bar.barcode?   #=> true
bar.code?      #=> false
```

### 隨機品項：`Warehouse::Item::Random`

`Warehouse::Item::Random.new(items, qty)`：從 `items` 隨機抽 `qty` 次（可重複），結果合併成 `Warehouse::List`。

```ruby
item1 = Warehouse::Item::Code.new("BLACK", "迷黑", nil, 250)
item2 = Warehouse::Item::Code.new("YELLOW", "迷黃", nil, 250)
item3 = Warehouse::Item::Code.new("GREEN", "迷綠", nil, 250)

random_item = Warehouse::Item::Random.new([item1, item2, item3], 4)

list = random_item.fetch!   # 每次呼叫都重新抽，回傳 Warehouse::List
list.to_h.values.sum        #=> 4（各料號數量加總 = 抽取次數）
random_item.fetch           # 抽一次並快取，之後回傳同一份結果
```

### 清單：`Warehouse::List`

```ruby
item1 = Warehouse::Item::Code.new("BLACK", "迷黑", 1, 250)
item2 = Warehouse::Item::Code.new("YELLOW", "迷黃", 1, 250)
list  = Warehouse::List.new([item1, item2])

# 所有數量變兩倍（回傳新清單；隨機品項會先被展開成實際抽到的品項）
(list * 2).to_h          #=> { "BLACK" => 2, "YELLOW" => 2 }

# 加入品項：同料號 / 同條碼會累加數量，否則新增一筆（回傳新清單，不會改到原本的 list）
(list + item1).to_h      #=> { "BLACK" => 2, "YELLOW" => 1 }
(list + Warehouse::Item::Barcode.new("4710000000002", "條碼品項", 2)).to_h
#=> { "BLACK" => 1, "YELLOW" => 1, "4710000000002" => 2 }

# 清單 + 清單
(list + list).to_h       #=> { "BLACK" => 2, "YELLOW" => 2 }

# 展開隨機品項（回傳新清單，內容都是已經抽好的實際品項）
Warehouse::List.new([random_item]).items!

# 查詢
list.find("BLACK")                       # 依 code 或 barcode 找，找不到回 nil
list.find("BLACK", type: :code)          # 只找 code
list.find("4710000000002", type: :barcode)

list.to_h   #=> { "BLACK" => 1, "YELLOW" => 1 }        料號（或條碼）=> 數量
list.to_a   #=> [{ "code" => "BLACK", ... }, ...]      每個品項的 to_h

list.length; list.map(&:code); list.each { |i| ... }; list.empty?
Warehouse::List.none.empty?  #=> true
```

> 注意：`+` 與 `*` 都會回傳新的清單，不會修改原本的清單；`list += item` 會把變數指到新清單。

## 開發與測試

```bash
git clone https://github.com/superlanding/warehouse_items.git
cd warehouse_items
bin/setup

# 與 CI 相同：指定 gemfile 後跑測試（gemfiles/rails_7.0.gemfile … rails_8.1.gemfile）
BUNDLE_GEMFILE=$PWD/gemfiles/rails_8.1.gemfile bundle install
BUNDLE_GEMFILE=$PWD/gemfiles/rails_8.1.gemfile bundle exec rake t

bin/console   # 互動式 console
```

測試使用 Minitest + shoulda-context，檔案在 `test/**/*_test.rb`。`rake`（預設 task）也會跑測試。

## 發版流程

使用 RubyGems [Trusted Publishing](https://guides.rubygems.org/trusted-publishing/)，repo 內不存放任何 API key：

1. 在 PR 裡修改 `lib/warehouse/version.rb` 的 `Warehouse::VERSION`（Semantic Versioning：修 bug 跳 patch、相容的新功能跳 minor、不相容變更跳 major）。
2. 在 `CHANGELOG.md` 新增對應的版本章節與說明。
3. PR 經過 review 後**由真人合併到 `master`**（AI 帳號只能開 PR，不能合併）。
4. [`.github/workflows/publish.yml`](.github/workflows/publish.yml) 在 master 上執行：比對 gemspec 版本與 rubygems.org，跑測試，
   若是新版本就發佈並打 `vX.Y.Z` tag。沒有跳版號的合併不會發佈任何東西。

只改文件或 CI 的 PR 不需要跳版號。貢獻規則見 [CLAUDE.md](CLAUDE.md)（每個 PR 都必須同步更新 `README.md` 與 `CHANGELOG.md`）。

## 授權

[MIT License](LICENSE.txt)。
