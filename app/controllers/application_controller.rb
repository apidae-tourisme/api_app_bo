class ApplicationController < ActionController::Base
  protect_from_forgery

  after_filter :set_access_control_headers

  def handle_options_request
    head(:ok) if request.request_method == 'OPTIONS'
  end

  def find_node(node_id)
    Neo4j::Session.current.query.match(n: {uuid: node_id}).return(:n).first ||
        Neo4j::Session.current.query.match(n: {uid: node_id.to_s}).return(:n).first
  end


  private

  def set_access_control_headers
    headers['Access-Control-Allow-Origin'] = '*'
    headers['Access-Control-Allow-Methods'] = 'GET, PUT, POST, DELETE, OPTIONS, PATCH'
    headers['Access-Control-Allow-Headers'] =
        'Origin, X-Requested-With, Content-Type, Accept, If-Modified-Since, Expiry, Access-Token, Client, Token-Type, Uid'
    headers['Access-Control-Expose-Headers'] = 'Expiry, Access-Token, Client, Token-Type, Uid'
  end
end
