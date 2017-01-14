class SeedController < ApplicationController
  include SeedFormConcern

  before_filter :authenticate_admin!

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
    @seed = @seed_class.new(nullify(seed_params))

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
      if @seed.update(nullify(seed_params))
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

  # Blank values generate 0-values in int and float properties otherwise
  def nullify(hsh)
    n_hsh = hsh.dup
    hsh.each_pair do |k, v|
      n_hsh[k] = nil if v.blank?
    end
    n_hsh
  end
end
