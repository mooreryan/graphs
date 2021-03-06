require 'set'
require 'fail_fast'

# There can only be a single node with a particular name. Also,
# connections are assumed to be undirected.
class Graph
  attr_accessor :nodes

  def initialize
    @nodes = {}
  end

  def each
    @nodes.each do |name, node|
      yield node
    end
  end

  def to_s
    @nodes.map { |name, node| node.inspect }.join "\n"
  end

  # @param node [Node] the node to check for
  def has_node? node
    @nodes.include? node.name
  end

  # If the node already exists, add the connections to existing node
  #
  # @param node [Node] the node to add
  def add node
    name = node.name
    if @nodes.has_key? name
      @nodes[name].add_connections node.connections
    else
      @nodes[name] = node
    end
  end

  def df_search starting_name
    stack = []
    nodes_visited = Set.new

    name = starting_name

    while name
      unless nodes_visited.include? name
        nodes_visited << name
        node = @nodes[name]
        assert node

        node.connections.each do |node|
          stack << node
        end
      end

      name = stack.pop
      unless name
        assert nodes_visited
        return nodes_visited
      end
    end
  end

  def node_names
    @nodes.keys
  end
end
