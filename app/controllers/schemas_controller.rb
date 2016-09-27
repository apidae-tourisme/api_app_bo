class SchemasController < ApplicationController
  before_action :set_schema, only: [:show, :edit, :update, :destroy]

  def index
    @seeds = Schema.all
  end

  def show
  end

  def new
    @schema = Schema.new
  end

  def edit
  end

  def create
    @schema = Schema.new(schema_params)

    respond_to do |format|
      if @schema.save
        format.html { redirect_to @schema, notice: 'Schema was successfully created.' }
        format.json { render :show, status: :created, location: @schema }
      else
        format.html { render :new }
        format.json { render json: @schema.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @schema.update(schema_params)
        format.html { redirect_to @schema, notice: 'Schema was successfully updated.' }
        format.json { render :show, status: :ok, location: @schema }
      else
        format.html { render :edit }
        format.json { render json: @schema.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @schema.destroy
    respond_to do |format|
      format.html { redirect_to schemas_url, notice: 'Schema was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    def set_schema
      @schema = Schema.find(params[:id])
    end

    def schema_params
      params.require(:schema).permit(:created_at, :updated_at, :name, :description, :thumbnail)
    end
end
