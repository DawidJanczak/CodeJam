#!/usr/bin/ruby

class KingdomRush
  def initialize(nr_of_levels, stars_needed)
    @nr_of_levels = nr_of_levels
    @stars_needed = stars_needed
    @stars = 0
    @times_played = 0
  end

  def play_second_star
    level_played = @stars_needed.find { |level| level[1] <= @stars }
    return false if level_played.nil?

    level_played[2] == true ? @stars += 1 : @stars += 2
    @times_played += 1
    @stars_needed.delete(level_played)
    true
  end

  def play_first_star
    level_played = @stars_needed.select { |level| level[2] == false && level[0] <= @stars }.sort { |l1, l2| l1[0] <=> l2[0] }.max { |l1, l2| l1[1] <=> l2[1] }
    return false if level_played.nil?

    @stars += 1
    @times_played += 1
    level_played[2] = true
    true
  end

  def play
    levels_finished = 0
    return "Too Bad" unless @stars_needed.any? { |s| s[0] == 0 }
    until @stars_needed.empty? do
      finished = play_second_star
      finished ||= play_first_star
      return "Too Bad" unless finished
    end
    @times_played
  end
end

contents = File.readlines(ARGV[0])
nr_of_tcs = contents.delete_at(0).to_i

File.open('output.txt', 'w') do |f|
  nr_of_tcs.times do |tc_nr|
    nr_of_levels = contents.shift.to_i
    stars = contents.shift(nr_of_levels).map.with_index { |level, index| level.split.map { |i| i.to_i } << false << index }
    f.puts "Case ##{tc_nr + 1}: #{KingdomRush.new(nr_of_levels, stars).play}"
    puts "Case ##{tc_nr + 1} solved"
  end
end
