# make the network into a json for use in D3

nodes = []
node_nums = {}
links = []
connections = []

num = 0
ARGF.each_line do |line|
  target, query = line.chomp.split "\t"
  connections << [target, query]

  # give every node a unique number

  if !node_nums.has_key?(target)
    node_nums[target] = num
    num += 1
  end

  if !node_nums.has_key?(query)
    node_nums[query] = num
    num += 1
  end
end

connections.each do |source, target|
  links << %Q[{"source":#{node_nums[source]},"target":#{node_nums[target]}}]
end

node_nums.sort_by { |node, num| num }.each do |node, num|
  nodes << %Q[{"name":#{node},"graph":0}]
end

json = %Q[{"nodes":#{nodes.join(",")},"links":#{links.join(",")}}]

puts json
