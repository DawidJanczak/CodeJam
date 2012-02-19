raise "Input filename should be given as script argument!" unless ARGV.size > 0

class PascalsTriangle
  def initialize
    @rows = [[1]]
    @row_sums = [1]
  end

  #Gets row from Pascal's Triangle as an array of numbers.
  #Rows are numbered from 0 and are remembered inside the class.
  #In case row was not yet resolved it is filled along with its predecessors
  #that were not yet filled.
  def get_row(row)
    if @rows[row].nil?
      @rows.size.upto(row) do |row_to_fill|
        new_row = [1]
        @rows.last[0...-1].each_index { |index| new_row << @rows.last[index] + @rows.last[index + 1] }
        new_row << 1

        @rows << new_row
        @row_sums << new_row.inject(:+)
      end
    end

    @rows[row]
  end

  def sum_row(row)
    get_row(row)
    @row_sums[row]
  end
end

class EggDrop
  @@MAX_F_VAL = 2 ** 32

  def initialize
    @pascal_triangle = PascalsTriangle.new
    @f = @d = @b = 0
  end

  #Initializes f, d and b according to a three elem array
  def new_case(params)
    @f, @d, @b = params
  end

  def f_max
    result = get_max_f(@d, @b)
    result < @@MAX_F_VAL ? result : -1
  end

  def d_min
    @d.downto(0) { |d| return d + 1 if get_max_f(d, @b) < @f }
  end

  def b_min
    @b.downto(0) { |b| return b + 1 if get_max_f(@d, b) < @f }
  end

  def get_solution
    "%s %s %s" % [f_max, d_min, b_min]
  end

  private

  def get_max_f(d, b)
    @pascal_triangle.get_row(d)[0..b].inject(:+) - 1
  end
end

egg_drop = EggDrop.new
testcases = File.readlines(ARGV[0]).drop(1)

File.open('output.txt', 'w') do |f|
  testcases.size.times do |tc|
    egg_drop.new_case(testcases.shift.split.map { |el| el.to_i })
    f.puts "Case ##{tc + 1}: #{egg_drop.get_solution}"
  end
end
