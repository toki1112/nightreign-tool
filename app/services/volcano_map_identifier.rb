class VolcanoMapIdentifier
  CHECK_POSITIONS = [
    { position_name: "8", label: "右上" },
    { position_name: "7", label: "左上" },
    { position_name: "17", label: "右下" }
  ]

  POSITION_LABELS = {
  "1" => "北西",
  "2" => "北西",
  "3" => "東",
  "4" => "南",
  "5" => "南西",
  "6" => "南東",
  "18" => "一日目の夜",
  "19" => "一日目の夜",
  "20" => "一日目の夜",
  "21" => "一日目の夜",
  "22" => "一日目の夜",
  "23" => "一日目の夜",
  "24" => "一日目の夜",
  "25" => "一日目の夜",
  "26" => "二日目の夜",
  "27" => "中央砦屋上",
  "28" => "中央砦",
  "29" => "中央砦地下",
}

  def initialize(boss:, night_lord:, terrain_change:)
    @boss = boss
    @night_lord = night_lord
    @terrain_change = terrain_change
  end

  def call
    patterns = map_patterns.map do |map_pattern|
      {
        map_pattern: map_pattern,
        keys: identification_keys(map_pattern)
      }
    end

    confirmed_patterns = []
    duplicate_groups = [patterns]

    CHECK_POSITIONS.each_with_index do |_position_name, key_index|
      next_duplicate_groups = []

      duplicate_groups.each do |target_patterns|
        grouped_patterns = grouped_by_key_index(target_patterns, key_index)

        grouped_patterns.each do |_outpost_name, patterns|
          if patterns.count == 1
            confirmed_patterns << {
              map_pattern: patterns.first[:map_pattern],
              used_keys: patterns.first[:keys].first(key_index + 1),
              boss_position: boss_position(patterns.first[:map_pattern])
            }
          else
            next_duplicate_groups << patterns
          end
        end
      end

      duplicate_groups = next_duplicate_groups
    end

    confirmed_patterns.select do |confirmed_pattern|
      MapObject.exists?(
        boss: @boss,
        map_pattern: confirmed_pattern[:map_pattern]
      )
end
  end

  private

  def map_patterns
    MapPattern
      .includes(map_objects: [:outpost, :boss])
      .where(
        night_lord: @night_lord,
        terrain_change: @terrain_change
        )
  end

  def identification_keys(map_pattern)
    CHECK_POSITIONS.map do |check_position|
      map_object = map_pattern.map_objects.find_by(
        position_name: check_position[:position_name]
      )

      {
        label: check_position[:label],
        outpost_name: map_object&.outpost&.name
      }
    end
  end

  def grouped_by_key_index(patterns, key_index)
    patterns.group_by do |pattern|
      pattern[:keys][key_index][:outpost_name]
    end
  end

  def boss_position(map_pattern)
    map_object = map_pattern.map_objects.find do |object|
      object.boss_id == @boss.id
    end

    return nil if map_object.blank?

    {
      position_name: map_object.position_name,
      label: POSITION_LABELS[map_object.position_name] || map_object.position_name
    }
  end
end
