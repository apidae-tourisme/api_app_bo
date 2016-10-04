class SeedController < ApplicationController
  before_action :set_seed_class
  before_action :set_seed, only: [:show, :edit, :update, :destroy]

  def index
    @seeds = @seed_class.all
  end

  def show
  end

  def new
    @seed = @seed_class.new
  end

  def edit
  end

  def create
    @seed = @seed_class.new(seed_params)

    respond_to do |format|
      if @seed.save
        format.html { redirect_to send("#{@seed.class.to_s.pluralize.underscore}_url"), notice: 'La graine a bien été créée.' }
        format.json { render :show, status: :created, location: @seed }
      else
        format.html { render :new }
        format.json { render json: @seed.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @seed.update(seed_params)
        format.html { redirect_to send("#{@seed.class.to_s.pluralize.underscore}_url"), notice: 'La graine a bien été mise à jour.' }
        format.json { render :show, status: :ok, location: @seed }
      else
        format.html { render :edit }
        format.json { render json: @seed.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @seed.destroy
    respond_to do |format|
      format.html { redirect_to send("#{@seed.class.to_s.pluralize.underscore}_url"), notice: 'La graine a bien été supprimée.' }
      format.json { head :no_content }
    end
  end

  private

  def set_seed_class
    @seed_class = controller_name.classify.constantize
  end

  def set_seed
    @seed = @seed_class.find(params[:id])
  end
end
