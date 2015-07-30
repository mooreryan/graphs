#!/usr/bin/env ruby

require 'set'
require 'fail_fast'
require 'parse_fasta'
require_relative 'graph'
require_relative 'node'

include FailFast::Assertions

# connections = [
#   ['a', 'b'],
#   ['b', 'c'],
#   ['b', 'd'],
#   ['f', 'e'],
#   ['f', 'h'],
#   ['g', 'h'],
#   ['b', 'h'],
#   ['z', 'y'],
#   ['y', 'x'],
#   ['x', 'z'],
#   ['a', 'z']
# ]

connections = []
ARGF.each_line do |line|
  connections << line.chomp.split("\t")
end

graph = Graph.new

# make each connection a two way connection
connections.each do |source, target|
  n1 = Node.new target, [source]
  n2 = Node.new source, [target]

  graph.add n1
  graph.add n2
end

visited = Set.new
not_visited = Set.new graph.node_names

connected_sets = []
while !not_visited.empty?
  a_node = not_visited.to_a.sample
  nodes = graph.df_search(a_node)
  assert nodes
  connected_sets << nodes

  # this is the muuuch faster way
  nodes.each { |node| not_visited.delete node }
  # nodes.each { |node| visited << node }
  # not_visited = not_visited - visited
end

connected_sets.each_with_index do |set, i|
  set.each do |name|
    printf "%s\t%d\n", name, i+1
  end
end

$stderr.printf "Number of subgraphs: %d\n", connected_sets.count
