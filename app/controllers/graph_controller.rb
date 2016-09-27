class GraphController < ApplicationController
  def node
    @nodes = []
    @links = []
    if params[:id] == 'root'
      node = Neo4j::Session.current.query.match(n: {reference: 'Apidae'}).return(:n).first
    else
      node = Neo4j::Session.current.query.match(n: {uuid: params[:id]}).return(:n).first
    end
    if node
      node_seed = node.n
      @nodes << node_seed
      linked_nodes = node_seed.connected_seeds
      linked_nodes.each do |nd|
        @nodes << nd
        @links << {source: nd.id, target: node_seed.id}
      end
    end
  end

  def nodes
    @nodes = Neo4j::Session.current.query.match(:n).return(:n).collect {|res| res.n}
  end
end
