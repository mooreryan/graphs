require 'set'

class Node
  attr_accessor :name, :connections

  # @param name [String]
  # @param connections [Array<String>] array of names of connections
  def initialize name, connections
    @name = name
    @connections = Set.new connections
  end

  def add_connections arr_of_node_names
    arr_of_node_names.each do |name|
      @connections << name
    end
  end
end
