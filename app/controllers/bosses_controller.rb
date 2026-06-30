class BossesController < ApplicationController
  def index
    @q = Boss.ransack(params[:q])
    @bosses = @q.result(distinct: true)

    @boss_results = @bosses.map do |boss|
      grouped_map_objects = boss.map_objects.group_by do |map_object|
        map_pattern = map_object.map_pattern

        [
          map_pattern.night_lord_id,
          map_pattern.terrain_change_id
        ]
      end

      # 候補を夜の王と地変と確率でハッシュ化
      grouped_results = grouped_map_objects.map do |key, map_objects|
        night_lord = NightLord.find(key[0])
        terrain_change = TerrainChange.find(key[1])

        {
          night_lord: night_lord,
          terrain_change: terrain_change,
          probability: map_objects.count * 100 / 5
        }
      end

      # 並び替え (確率が被った際には夜の王idが若いものから選ぶ)
      grouped_results = grouped_results.sort_by do |grouped_result|
        [
          -grouped_result[:probability],
          grouped_result[:night_lord].id
        ]
      end

      # 確率が上位二件のものを表示
      grouped_results = grouped_results.first(2)

      
      {
          boss: boss,
          grouped_results: grouped_results
      }
    end
  end
end
