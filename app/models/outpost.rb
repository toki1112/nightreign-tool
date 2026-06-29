class Outpost < ApplicationRecord
  has_many :map_objects, dependent: :destroy

  enum :outpost_type, {
    great_church: 0,  # 大教会
    small_fort: 1,    # 小砦
    large_camp: 2,    # 大野営地
    ruins: 3          # 遺跡
  }

  enum :element_type, {
    neutral: 0,
    fire: 1,        # 火
    lightning: 2,   # 雷
    holy: 3,        # 聖
    magic: 4,       # 魔
    poison: 5,      # 毒
    rot: 6,         # 腐敗
    frost: 7,       # 冷気
    bleed: 8,       # 出血
    madness: 9,     # 発狂
    sleep: 10,      # 睡眠
    death: 11       # 死
  }
end
