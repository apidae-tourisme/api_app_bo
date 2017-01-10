class SeedsController < ApplicationController

  before_action :set_user
  before_action :set_seed, only: [:show, :edit, :update, :details]
  before_action :set_seed_context, only: [:show]

  DEFAULT_NODE = 'default'

  def index
    @seeds = []
    unless params[:query].blank?
      @seeds = Neo4j::Session.current.query.match(:n).where("n.name IS NOT NULL")
                   .where("n.archived IS NULL OR n.archived <> TRUE")
                   .where("n.scope = 'public' OR n.scope IS NULL OR (n.scope = 'private' AND n.last_contributor = {author})")
                   .where("n.name =~ {pattern}")
                   .params(author: @user.email, pattern: "(?i).*#{params[:query]}.*")
                   .pluck(:n)
    end
  end

  def show
  end

  def create
    input_params = seed_params
    unless input_params[:type].blank?
      @seed = build_from_type(input_params[:type], input_params.except(:type))
      @seed.log_entry(@user.email)
      if @seed.save
        render :create, status: :ok
      else
        render json: @seed.errors, status: :unprocessable_entity
      end
    end
  end

  def edit
  end

  def update
    @seed.attributes = seed_params
    @seed.log_entry(@user.email)
    if @seed.save
      render :update, status: :ok
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
    node_entry = nil
    if params[:id] == DEFAULT_NODE
      node_entry = default_node
    elsif @user
      node_entry = find_node(params[:id], @user.email)
    end
    @seed = node_entry.n unless node_entry.nil?
  end

  def set_seed_context
    @seeds = []
    @links = []
    if @seed
      @seeds << @seed
      linked_nodes = @user ? @seed.visible_seeds(@user) : []
      linked_nodes.each do |nd|
        @seeds << nd
        @links << {source: nd.id, target: @seed.id}
      end
    end
  end

  def seed_params
    params.require(:seed).permit(:type, :name, :author, :description, :thumbnail, :firstname, :lastname, :telephone,
                                 :mobilephone, :started_at, :ended_at, :archived, :scope, urls: [], seeds: [])
  end

  def build_from_type(seed_type, attrs)
    case seed_type
      when 'person'
        Person.new(attrs)
      when 'organization'
        Organization.new(attrs)
      when 'competence'
        Competence.new(attrs)
      when 'event'
        Event.new(attrs)
      when 'project'
        Project.new(attrs)
      when 'action'
        Task.new(attrs)
      when 'creativework'
        CreativeWork.new(attrs)
      when 'product'
        Product.new(attrs)
      when 'idea'
        Idea.new(attrs)
      when 'concept'
        Concept.new(attrs)
      when 'schema'
        Schema.new(attrs)
      else
    end
  end
end
