class PicturesController < ApplicationController
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
end
