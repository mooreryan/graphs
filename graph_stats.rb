#!/usr/bin/env ruby
# graph_counts = Hash.new 0
# File.open(ARGV.first).each_line do |line|
#   contig, graph = line.chomp.split "\t"
#   graph_counts[graph.to_i] += 1
# end

# puts %w[graph count].join "\t"
# graph_counts.sort_by { |g, c| g }.each do |graph, count|
#   puts [graph, count].join "\t"
# end

require "fail_fast"

include FailFast::Assertions

graph_info = {}
File.open("la.txt").each_line do |line|
  unless line.start_with? "contig"
    contig, len, cov, graph, taxa, order, taxa_cov = line.chomp.split "\t"
    graph = graph.to_i
    if graph_info.has_key? graph
      graph_info[graph][:contigs] << contig
      graph_info[graph][:lens] << len.to_i
      graph_info[graph][:covs] << cov.to_i
      graph_info[graph][:taxas] << taxa
      graph_info[graph][:orders] << order
      graph_info[graph][:taxa_covs] << taxa_cov
    else
      graph_info[graph] = { contigs: [contig],
                            lens: [len.to_i],
                            covs: [cov.to_i],
                            taxas: [taxa],
                            orders: [order],
                            taxa_covs: [taxa_cov.to_f] }
    end
  end
end

def mean arr
  assert !arr.empty?

  arr.reduce(:+) / arr.count.to_f
end

def median arr
  assert !arr.empty?

  a = arr.sort
  len = arr.length

  if len.odd?
    arr[len / 2]
  else
    (arr[len / 2] + arr[(len/2) - 1]) / 2.0
  end
end

def mode arr
  assert !arr.empty?

  arr.group_by { |n| n.round }.
    sort_by { |n, arr| arr.count }.
    reverse.
    first.
    first
end

num_graphs = graph_info.count.to_f
singleton_graphs = 0
single_taxa_graphs = 0
single_order_graphs = 0

nonsingleton_single_taxa = 0
nonsingleton_single_order = 0

graph_stuff = {}
graph_info.each do |graph, info|
  num = info[:contigs].count
  graph_stuff[graph] = { sing: false,
                         sing_taxa: false,
                         sing_order: false,
                         size: 0,
                         mean_cov: 0,
                         median_cov: 0,
                         mode_cov: 0 }

  graph_stuff[graph][:size] = num
  assert info.values.all? { |arr| arr.count == num }

  if num == 1
    singleton_graphs += 1
    graph_stuff[graph][:sing] = true
  end

  if info[:taxas].uniq.count == 1
    single_taxa_graphs += 1
    graph_stuff[graph][:sing_taxa] = info[:taxas].first
  end

  if info[:orders].uniq.count == 1
    single_order_graphs += 1
    graph_stuff[graph][:sing_order] = info[:orders].first
  end

  if num > 1 && info[:taxas].uniq.count == 1
    nonsingleton_single_taxa += 1
  end

  if num > 1 && info[:orders].uniq.count == 1
    nonsingleton_single_order += 1
  end

  graph_stuff[graph][:mean_cov] = mean(info[:covs])
  graph_stuff[graph][:median_cov] = median(info[:covs])
  graph_stuff[graph][:mode_cov] = mode(info[:covs])
end
non_singletons = num_graphs - singleton_graphs

$stderr.puts %w[singletons single.taxa nonsingleton.single.taxa single.order nonsingleton.single.order].join "\t"
$stderr.puts [singleton_graphs / num_graphs,
      single_taxa_graphs / num_graphs,
      nonsingleton_single_taxa / non_singletons,
      single_order_graphs / num_graphs,
      nonsingleton_single_order / non_singletons,].join "\t"

puts %w[graph singleton single.taxa single.order size cov.mean cov.median cov.mode].join "\t"
graph_stuff.sort_by { |g, i| g }.each do |graph, info|
  puts [graph, info[:sing], info[:sing_taxa], info[:sing_order],
        info[:size], info[:mean_cov], info[:median_cov],
        info[:mode_cov]].join "\t"
end
