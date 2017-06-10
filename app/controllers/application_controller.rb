class ApplicationController < ActionController::Base
  protect_from_forgery

  after_filter :set_access_control_headers

  def handle_options_request
    head(:ok) if request.request_method == 'OPTIONS'
  end

  def find_node(node_id, author)
    Neo4j::Session.current.query.match(:n)
        .where("(n.uuid = {uuid} OR n.uid = {uid} OR n.reference = {ref}) AND (n.scope = {public} OR n.scope IS NULL OR (n.scope = {private} AND n.last_contributor = {author}))")
        .params(uuid: node_id, uid: node_id, ref: node_id, author: author, public: SeedEntity::SCOPE_PUBLIC, private: SeedEntity::SCOPE_PRIVATE)
        .return(:n).first
  end

  def find_public_node(node_id)
    Neo4j::Session.current.query.match(:n)
        .where("(n.uuid = {uuid} OR n.uid = {uid} OR n.reference = {ref}) AND (n.scope = {public} OR n.scope IS NULL)")
        .params(uuid: node_id, uid: node_id, ref: node_id, public: SeedEntity::SCOPE_PUBLIC)
        .return(:n).first
  end

  def default_node
    Neo4j::Session.current.query.match(n: {reference: 'Apidae'}).return(:n).first
  end

  private

  def set_access_control_headers
    headers['Access-Control-Allow-Origin'] = '*'
    headers['Access-Control-Allow-Credentials'] = 'true'
    headers['Access-Control-Allow-Methods'] = 'GET, PUT, POST, DELETE, OPTIONS, PATCH'
    headers['Access-Control-Allow-Headers'] =
        'Origin, X-Requested-With, Content-Type, Accept, If-Modified-Since, Expiry, Access-Token, Client, Token-Type, Uid'
    headers['Access-Control-Expose-Headers'] = 'Expiry, Access-Token, Client, Token-Type, Uid'
  end
end
