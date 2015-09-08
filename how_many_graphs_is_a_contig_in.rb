graphs = Hash.new 0
File.open(ARGV.first).each_line do |line|
  contig, graph = line.chomp.split "\t"
  graphs[contig] += 1
end

puts %w[contig num.graphs].join "\t"
graphs.each do |contig, graph_count|
  puts [contig, graph_count].join "\t"
end
