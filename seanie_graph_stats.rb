#!/usr/bin/env ruby
contig_graphs = ARGV[0]
contig_assemblies = ARGV[1]

assemblies = {}
File.open(contig_assemblies).each_line do |line|
  contig, assembly = line.chomp.split "\t"

  if assemblies.has_key? contig
    warn "|#{contig}| is repeated in |#{contig_assemblies}|"
    if assemblies[contig] != assembly
      abort "the reported assemblers are different"
    end
  else
    assemblies[contig] = assembly
  end
end

all_assemblies = assemblies.values.uniq.sort

graphs = {}
File.open(contig_graphs).each_line do |line|
  contig, graph = line.chomp.split "\t"

  if assemblies.has_key? contig
    assembly = assemblies[contig]
  else
    abort "#{contig} is not present in #{contig_assemblies}"
  end

  if graphs.has_key? graph
    graphs[graph] << assembly
  else
    graphs[graph] = [assembly]
  end
end

puts ["graph", "total", all_assemblies].flatten.join "\t"
graphs.each do |graph, assms|
  counts = Hash.new 0
  assm_counts = assms.group_by { |n| n }.map { |a, arr| [a, arr.count] }
  assm_counts.each do |assem, count|
    counts[assem] = count
  end

  total = assm_counts.reduce(0) { |tot, (_, count)| tot + count }.to_f

  percs = all_assemblies.map do |assem|
    counts[assem] / total
  end

  puts [graph, total, percs].flatten.join "\t"
end
