# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
require "csv"

# 本番運用後はBossなどのマスターデータを削除して再投入しないこと。
# StrategyPostがboss_idでBossを参照しているため、BossのIDが変わると投稿との紐づきが壊れる。
# 本番運用後のマスターデータ更新は追加のみで行う。
# 依存関係があるテーブルから先に削除
MapObject.delete_all
MapPattern.delete_all
# Boss.delete_all
Outpost.delete_all
TerrainChange.delete_all
NightLord.delete_all

# IDを1から振り直す
ActiveRecord::Base.connection.reset_pk_sequence!("night_lords")
ActiveRecord::Base.connection.reset_pk_sequence!("terrain_changes")
# ActiveRecord::Base.connection.reset_pk_sequence!("bosses")
ActiveRecord::Base.connection.reset_pk_sequence!("outposts")
ActiveRecord::Base.connection.reset_pk_sequence!("map_patterns")
ActiveRecord::Base.connection.reset_pk_sequence!("map_objects")

CSV.foreach(Rails.root.join("db/seeds/night_lords.csv"), headers: true, encoding: "bom|utf-8") do |row|
  NightLord.create!(
    name: row["name"],
    icon: row["icon"].presence
  )
end

CSV.foreach(Rails.root.join("db/seeds/terrain_changes.csv"), headers: true, encoding: "bom|utf-8") do |row|
  TerrainChange.create!(name: row["name"])
end

CSV.foreach(Rails.root.join("db/seeds/bosses.csv"), headers: true, encoding: "bom|utf-8") do |row|
  Boss.find_or_create_by!(name: row["name"])
end

CSV.foreach(Rails.root.join("db/seeds/outposts.csv"), headers: true, encoding: "bom|utf-8") do |row|
  Outpost.create!(
    name: row["name"],
    outpost_type: row["outpost_type"],
    icon: row["icon"].presence,
    element_type: row["element_type"].presence,
    element_icon: row["element_icon"].presence
  )
end

CSV.foreach(Rails.root.join("db/seeds/map_patterns.csv"), headers: true, encoding: "bom|utf-8") do |row|
  MapPattern.create!(
    night_lord_id: row["night_lord_id"],
    terrain_change_id: row["terrain_change_id"],
    pattern_no: row["pattern_no"]
  )
end

night_lord_name_map = {
  "gladius" => "グラディウス",
  "adel" => "エデレ",
  "gnoster" => "グノスター",
  "maris" => "マリス",
  "libra" => "リブラ",
  "fulghor" => "フルゴール",
  "caligo" => "カリゴ",
  "nameless" => "ナメレス",
  "harmonia" => "ハルモニア",
  "straghess" => "ストラゲス"
}

terrain_name_map = {
  "volcano" => "火山",
  "snow" => "山嶺",
  "rotwoods" => "腐れ森",
  "noklateo" => "ノクラテオ"
}

Dir[Rails.root.join("db/seeds/map_objects/**/*.csv")].sort.each do |csv_path|
  path = Pathname.new(csv_path.to_s)

  night_lord_key = path.dirname.basename.to_s
  file_name = path.basename(".csv").to_s

  match = file_name.match(/\A(.+)_(\d+)\z/)
  terrain_key = match[1]
  pattern_no = match[2]

  night_lord = NightLord.find_by!(name: night_lord_name_map.fetch(night_lord_key))
  terrain_change = TerrainChange.find_by!(name: terrain_name_map.fetch(terrain_key))

  map_pattern = MapPattern.find_by!(
    night_lord_id: night_lord.id,
    terrain_change_id: terrain_change.id,
    pattern_no: pattern_no
  )

  CSV.foreach(csv_path, headers: true, encoding: "bom|utf-8") do |row|
    next if row["boss_id"].blank? && row["outpost_id"].blank?

    MapObject.create!(
      map_pattern_id: map_pattern.id,
      boss_id: row["boss_id"].presence,
      outpost_id: row["outpost_id"].presence,
      position_name: row["position_name"].presence,
      floor: row["floor"].presence,
      x: row["x"].presence,
      y: row["y"].presence
    )
  end
end
