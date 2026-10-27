# Changelog

本檔記錄此專案所有值得注意的變更。

格式參考 [Keep a Changelog](https://keepachangelog.com/zh-TW/1.1.0/)，版本號遵循 [Semantic Versioning](https://semver.org/lang/zh-TW/)。

## [Unreleased]

### Added

- 新增 `CHANGELOG.md`。
- README 重寫：簡介、需求、安裝、用法（`Item::Code` / `Item::Barcode` / `Item::Random` / `List`）、開發與測試、發版流程。
- CLAUDE.md 新增規則：每個 PR 都必須同步更新 `README.md` 與 `CHANGELOG.md`。
- CLAUDE.md 新增語言規則：`README.md` 與 `CHANGELOG.md` 一律用繁體中文（zh-TW）撰寫，程式碼、識別字與指令維持英文。

## [1.0.1] - 2026-10-27

### Added

- 支援 Rails（ActiveSupport）8 與 Ruby 3.3–3.4：gemspec 加上 `required_ruby_version >= 2.7`、放寬 bundler / rake 版本限制；明確 require ActiveSupport 的 `blank`、`delegation`。
- GitHub Actions 測試矩陣：Ruby 3.0–3.4 × Rails 7.0–8.1（`gemfiles/rails_*.gemfile`）。
- GitHub Actions `publish.yml`：master 收到新版本號時透過 RubyGems Trusted Publishing 自動發佈。
- CLAUDE.md（發版規則）。

### Fixed

- `Rakefile` 預設 task 改為 `:t`。

## [1.0.0] - 2022-08-09

### Added

- `Warehouse::Item::Code` 新增 `barcode`、`code_2`、`title_en` 欄位；`Warehouse::Item::Random#fetch!` 抽出的品項會帶上這些欄位。
- `Warehouse::Item::Code#is_free?`（`price == 0`）。
- `Warehouse::Item::Code.build(hash)`：由字串 key 的 hash 建立品項（`qty` 缺省為 0，`qty` / `price` 轉整數）。
- `.ruby-version`。

## [0.3.0] - 2019-04-17

### Changed

- `Warehouse::Item::Code` 與 `Warehouse::Item::Barcode` 改為 `Struct`（移除 `Item::Base`）。

## [0.2.0] - 2019-04-17

### Added

- `Warehouse::Item::Barcode`（以條碼表示的品項）。

### Changed

- 品項類別重構為 `Warehouse::Item::Code` / `Warehouse::Item::Barcode` / `Warehouse::Item::Random`；`Warehouse::Random` 移至 `Warehouse::Item::Random`。
- `Warehouse::List#find` 新增 `type:` 參數（`:code` / `:barcode`）；新增 `Warehouse::List#to_h`、`#to_a`。

## [0.1.1] - 2018-12-07

### Added

- random 測試。

### Fixed

- 修正 `Warehouse::Random` 的 bug。

## [0.1.0] - 2018-12-07

### Added

- 初始版本：`Warehouse::Item`、`Warehouse::Random`、`Warehouse::List`。

[Unreleased]: https://github.com/superlanding/warehouse_items/compare/v1.0.1...HEAD
[1.0.1]: https://github.com/superlanding/warehouse_items/releases/tag/v1.0.1
[1.0.0]: https://github.com/superlanding/warehouse_items/commit/a41c6ca
[0.3.0]: https://github.com/superlanding/warehouse_items/commit/642fa89
[0.2.0]: https://github.com/superlanding/warehouse_items/commit/02d6b2f
[0.1.1]: https://github.com/superlanding/warehouse_items/commit/d73b7c1
[0.1.0]: https://github.com/superlanding/warehouse_items/commit/fd16c22
