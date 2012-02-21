raise "Input filename should be given as script argument!" unless ARGV.size > 0

class EggDrop
  @@MAX_F_VAL = 2 ** 32
  @@STOP = -1

  def initialize(params)
    @f, @d, @b = params
    @f_max = @d_min = @b_min = 0
  end

  # Returns f_max, d_min and b_min in format specified by the task.
  def get_solution
  @f_max, @b_min, @d_min = f_max, b_min, d_min
    "%s %s %s" % [@f_max, @d_min, @b_min]
  end

  private

  # F_max is simply newton_sum of given d and b or -1 if the calculated
  # sum would be too big.
  def f_max
    result = get_newton_sum(@d, @b) { |sum| sum >= @@MAX_F_VAL }
  end

  # D_min should be calculated after b_min since d_min will never be lower
  # than b_min. This can be used for defining minimum possible d_min value.
  # The calculation itself consists of cutting d binary (from b_min to d)
  # and calculating newton_sum until finding first f value lower than given
  # in the input. d + 1 will then be the one that is required.
  def d_min
    min, max = @b_min, @d
    
    binary_cut(min, max) do |val|
      get_newton_sum(val, @b) { |sum| sum > @f }
    end
  end
  
  # The calculation for b_min consists of cutting d binary (from 0 to b)
  # and calculating newton_sum until finding first f value lower than given
  # in the input. b + 1 will then be the one that is required.
  def b_min
    min, max = 0, @b
  
    binary_cut(min, max) do |val|
      get_newton_sum(@d, val) { |sum| sum > @f }
    end
  end
  
  # Returns difference between min and max divided by two.
  # This difference is later used as a step in binary_cut.
  def step(min, max)
    (max - min) / 2
  end
  
  # This method should be ran with block to determine value
  # on found index. When max and min values are next to each
  # other, max is returned.
  def binary_cut(min, max)
    half = max - step(min, max)
    until max == min + 1 do
      floor = yield half

      if floor == @@STOP || floor >= @f
        max = half
        half -= step(min, max)
      else
        min = half
        half += step(min, max)
      end
    end
    
    max
  end
  
  # This method calculates newton sum for given d and b.
  # Binominal coefficient are summed as sum(C(d, i)),
  # where 1 <= i <= b.
  # Block passed to the function should have a conditional
  # expression to determine when to stop calculation based
  # on the calculated sum.
  # In case block evaluates to true, @@STOP is returned.
  def get_newton_sum(d, b)
    newton_value = newton_sum = 1
    (1..b).each do |i|
      
      # If conditional statement is met for given sum,
      # return STOP value.
      return @@STOP if yield newton_sum
      
      newton_value *= (d + 1 - i) / i.to_f
      newton_value = newton_value.round
      
      newton_sum += newton_value
      
      # There is a possibility that b > d during d_min
      # calculation.
      break if newton_value == 1
    end
    
    newton_sum.round - 1
  end
end

# First line from input (nr of testcases) is not needed.
testcases = File.readlines(ARGV[0]).drop(1)
File.open('output.txt', 'w') do |f|
  testcases.each_index do |tc_index|
    egg_drop = EggDrop.new(testcases[tc_index].split.map { |el| el.to_i })
    f.puts "Case ##{tc_index + 1}: #{egg_drop.get_solution}"
  end
end