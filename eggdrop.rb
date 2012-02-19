raise "Input filename should be given as script argument!" unless ARGV.size > 0

class EggDrop
  @@MAX_F_VAL = 2 ** 32

  def initialize
    @f = @d = @b = 0
  end

  #Initializes f, d and b according to a three elem array
  def new_case(params)
    @f, @d, @b = params
  end

  def f_max
    result = get_max_f_1(@d, @b)
  end

  def d_min
    found = false
    d = (@d / 2.0).ceil
    min, max = 0, @d
    until found do
      f_found = get_max_f_2(d, @b)

      if max == min + 1
        return max
      elsif f_found >= @f
        max = d
        d -= (max - min) / 2
      else
        min = d
        d += (max - min) / 2
      end
    end


    @d.downto(0) { |d| puts "D_min for d = #{d}"; return d + 1 if get_max_f(d, @b, false, true) < @f }
    #@b.upto(@d) { |d| puts "D_min for d = #{d}"; return d if get_max_f(d, @b) >= @f }
  end

  def b_min
    found = false
    b = (@b / 2.0).ceil
    min, max = 0, @b

    until found do
      f_found = get_max_f_2(@d, b)

      if max == min + 1
        return max
      elsif f_found >= @f
        max = b
        b -= (max - min) / 2
      else
        min = b
        b += (max - min) / 2
      end
    end
    #@b.downto(0) { |b| return b + 1 if get_max_f_3(@d, b) < @f }
    #val = get_max_f_3(@d, @b)
    #p "B min is #{val}"
    #val
  end

  def get_solution
    "%s %s %s" % [f_max, d_min, b_min]
  end

  private

  #def get_max_f(d, b)
    #@pascal_triangle.get_row(d)[0..b].inject(:+) - 1
  #end
  
  def get_max_f_1(d, b)
    previous = 1
    result = (1..b).inject(1) do |result, i| 
      return -1 if result >= @@MAX_F_VAL
      previous *= (d + 1 - i) / i.to_f
      result + previous
    end
    return result.round - 1
  end

  def get_max_f_2(d, b)
    previous = 1
    result = (1..b).inject(1) do |result, i| 
      previous *= (d + 1 - i) / i.to_f
      previous = previous.round
      return @f if (result + previous).round > @f
      return (result.round - 1) if (previous.round == 1)
      result + previous
    end
    return result.round - 1
  end

  def get_max_f_3(d, b)
    previous = 1
    result = (1..b).inject(1) do |result, i| 
      previous *= (d + 1 - i) / i.to_f
      return i if ((result + previous).round - 1) >= @f
      result + previous
    end
    return result.round - 1
  end

  #def get_max_f(d, b, stop_on_overflow = false)
    #p "f_max for #{d}, #{b}"
    #(0..b).inject(0) { |result, i| return -1 if stop_on_overflow && result >= @@MAX_F_VAL; result + newton(b, i) } - 1
  #end

  #def newton(n, k)
    #(1..k).inject(1) { |result, i| result * (n - i + 1) / i }
  #end
end

egg_drop = EggDrop.new
testcases = File.readlines(ARGV[0]).drop(1)

#egg_drop.new_case([1112818449, 855131647, 543194508])
#p egg_drop.d_min
#exit
t1 = Time.now
File.open('output.txt', 'w') do |f|
  testcases.size.times do |tc|
    egg_drop.new_case(testcases.shift.split.map { |el| el.to_i })
    f.puts "Case ##{tc + 1}: #{egg_drop.get_solution}"
  end
end
p "Time taken: #{Time.now - t1}"
