class CreativeWorksController < ApplicationController
  before_action :set_creative_work, only: [:show, :edit, :update, :destroy]

  def index
    @seeds = CreativeWork.all
  end

  def show
  end

  def new
    @creative_work = CreativeWork.new
  end

  def edit
  end

  def create
    @creative_work = CreativeWork.new(creative_work_params)

    respond_to do |format|
      if @creative_work.save
        format.html { redirect_to @creative_work, notice: 'Creative work was successfully created.' }
        format.json { render :show, status: :created, location: @creative_work }
      else
        format.html { render :new }
        format.json { render json: @creative_work.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @creative_work.update(creative_work_params)
        format.html { redirect_to @creative_work, notice: 'Creative work was successfully updated.' }
        format.json { render :show, status: :ok, location: @creative_work }
      else
        format.html { render :edit }
        format.json { render json: @creative_work.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @creative_work.destroy
    respond_to do |format|
      format.html { redirect_to creative_works_url, notice: 'Creative work was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    def set_creative_work
      @creative_work = CreativeWork.find(params[:id])
    end

    def creative_work_params
      params.require(:creative_work).permit(:created_at, :updated_at, :name, :description, :thumbnail, :url)
    end
end
