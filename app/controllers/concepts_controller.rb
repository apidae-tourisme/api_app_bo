class ConceptsController < ApplicationController
  before_action :set_concept, only: [:show, :edit, :update, :destroy]

  def index
    @concepts = Concept.all
  end

  def show
  end

  def new
    @concept = Concept.new
  end

  def edit
  end

  def create
    @concept = Concept.new(concept_params)

    respond_to do |format|
      if @concept.save
        format.html { redirect_to @concept, notice: 'Concept was successfully created.' }
        format.json { render :show, status: :created, location: @concept }
      else
        format.html { render :new }
        format.json { render json: @concept.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @concept.update(concept_params)
        format.html { redirect_to @concept, notice: 'Concept was successfully updated.' }
        format.json { render :show, status: :ok, location: @concept }
      else
        format.html { render :edit }
        format.json { render json: @concept.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @concept.destroy
    respond_to do |format|
      format.html { redirect_to concepts_url, notice: 'Concept was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    def set_concept
      @concept = Concept.find(params[:id])
    end

    def concept_params
      params.require(:concept).permit(:created_at, :updated_at, :name, :description, :thumbnail)
    end
end
