class SeedsController < ApplicationController

  before_action :set_user
  before_action :set_seed, only: [:show, :edit, :update, :details]

  DEFAULT_NODE = 'default'

  def index
    @seeds = Neo4j::Session.current.query.match(:n).order(n: {updated_at: :desc}).return(:n).collect {|res| res.n}
  end

  def show
    @seeds = []
    @links = []
    if @seed
      @seeds << @seed
      linked_nodes = @seed.connected_seeds
      linked_nodes.each do |nd|
        @seeds << nd
        @links << {source: nd.id, target: @seed.id}
      end
    end
  end

  def create

  end

  def edit

  end


  # Todo : whitelist attributes
  # bind JS attributes to ruby ones
  def update
    if @seed.update(seed_params)
      render :show, status: :ok
    else
      render json: @seed.errors, status: :unprocessable_entity
    end
  end

  def details
  end

  def search
    pattern = I18n.transliterate(params[:pattern])
    @seeds = Neo4j::Session.current.query.match(:n).where('(n.name =~ ?)', "(?i).*#{pattern}.*").
        order(n: {neo_id: :desc}).return(:n).collect {|res| res.n}
  end

  private

  def set_user
    uid = request.headers['Uid']
    @user = Person.where(uid: uid.to_i).first unless uid.blank?
  end

  def set_seed
    if params[:id] == DEFAULT_NODE
      node_entry = Neo4j::Session.current.query.match(n: {reference: 'Apidae'}).return(:n).first
    else
      node_entry = find_node(params[:id])
    end
    @seed = node_entry.n unless node_entry.nil?
    @seed.author = @user.email unless @user.nil?
  end

  def seed_params
    params.require(:seed).permit(:name, :description, :urls, :start_date, :end_date)
  end
end
