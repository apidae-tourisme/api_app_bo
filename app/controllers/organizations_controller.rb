class OrganizationsController < ApplicationController
  before_action :set_organization, only: [:show, :edit, :update, :destroy]

  def index
    @seeds = Organization.all
  end

  def show
  end

  def new
    @seed = Organization.new
  end

  def edit
  end

  def create
    @organization = Organization.new(organization_params)

    respond_to do |format|
      if @organization.save
        format.html { redirect_to @organization, notice: 'Organization was successfully created.' }
        format.json { render :show, status: :created, location: @organization }
      else
        format.html { render :new }
        format.json { render json: @organization.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @organization.update(organization_params)
        format.html { redirect_to @organization, notice: 'Organization was successfully updated.' }
        format.json { render :show, status: :ok, location: @organization }
      else
        format.html { render :edit }
        format.json { render json: @organization.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @organization.destroy
    respond_to do |format|
      format.html { redirect_to organizations_url, notice: 'Organization was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    def set_organization
      @seed = Organization.find(params[:id])
    end

    def organization_params
      params.require(:organization).permit(:created_at, :updated_at, :name, :description, :address, :email,
                                           :telephone, :thumbnail, :latitude, :longitude, :url)
    end
end
