class Node
  attr_accessor :name #, :connections

  # @param name [String]
  #
  # @param connections [Hash<String => Int>] Only the keys are used,
  #   this is faster than using Set
  def initialize name, connections
    @name = name
    # @connections = Set.new connections
    @connections = {}
    connections.each do |conn|
      @connections[conn] = 1
    end
  end

  def add_connections arr_of_node_names
    # arr_of_node_names.each do |name|
    #   @connections << name
    # end
    arr_of_node_names.each do |name|
      @connections[name] = 1
    end
  end

  def connections
    @connections.keys
  end
end
