#!/usr/bin/ruby

require_relative 'price_check.rb'

contents = File.readlines(ARGV[0])
contents.delete_at(0)

t1 = Time.now
File.open('output.txt', 'w') do |f|
  contents.each_slice(2).with_index do |slice, index|
    #if index == 11
      products = slice[0].split.map { |product| product.intern }
      guesses = slice[1].split.map { |price| price.to_i }
      price_check = PriceCheck.new(products, guesses)
      #f.puts "Case ##{index + 1}: #{price_check.switch.join(" ")}"
      f.puts "Case ##{index + 1}: #{price_check.test.join(" ")}"
      puts "Case ##{index + 1} solved"
    #end
  end
end
puts "Took #{Time.now - t1} seconds"
