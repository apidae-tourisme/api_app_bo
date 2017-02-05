class PicturesController < ApplicationController
  before_action :set_default_response_format

  def create
    unless params[:file].blank?
      @picture = Picture.new(img: params[:file])
      if @picture.save
        render :show, status: :ok
      else
        render json: @picture.errors, status: :unprocessable_entity
      end
    end
  end

  def show
    @picture = Picture.find(params[:id])
  end

  protected

  def set_default_response_format
    request.format = :json
  end
end
