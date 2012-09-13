#!/usr/bin/ruby

s1 = "ejp mysljylc kd kxveddknmc re jsicpdrysi"
s2 = "rbcpc ypc rtcsra dkh wyfrepkym veddknkmkrkcd"
s3 = "de kr kd eoya kw aej tysr re ujdr lkgc jv"

input = [s1, s2, s3]

s1_out = "our language is impossible to understand"
s2_out = "there are twenty six factorial possibilities"
s3_out = "so it is okay if you want to just give up"

output = [s1_out, s2_out, s3_out]

mapping = {}

input.zip(output) do |pair|
  pair[0].each_char.with_index do |char, index|
    mapping[char] = pair[1][index] unless mapping.keys.include?(char)
  end
end
mapping["z"] = "q"
mapping["q"] = "z"

def translate(string, map)
  output = ""
  string.each_char { |c| output << map[c] }
  output
end

contents = File.readlines(ARGV[0])
contents.delete_at(0)
File.open('output.txt', 'w') do |f|
  contents.each_with_index do |input_line, index|
    f.puts "Case ##{index + 1}: #{translate(input_line.chomp, mapping)}"
  end
end
