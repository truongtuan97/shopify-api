class GiftCardUsedsController < ApplicationController
  before_action :set_gift_card_used, only: [:show, :update, :destroy]

  # GET /gift_card_useds
  def index
    @gift_card_useds = GiftCardUsed.all

    render json: @gift_card_useds
  end

  # GET /gift_card_useds/1
  def show
    render json: @gift_card_used
  end

  # POST /gift_card_useds
  def create
    @gift_card_used = GiftCardUsed.new(gift_card_used_params)

    if @gift_card_used.save
      render json: @gift_card_used, status: :created, location: @gift_card_used
    else
      render json: @gift_card_used.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /gift_card_useds/1
  def update
    if @gift_card_used.update(gift_card_used_params)
      render json: @gift_card_used
    else
      render json: @gift_card_used.errors, status: :unprocessable_entity
    end
  end

  # DELETE /gift_card_useds/1
  def destroy
    @gift_card_used.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_gift_card_used
      @gift_card_used = GiftCardUsed.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def gift_card_used_params
      params.require(:gift_card_used).permit(:gift_card_code, :email, :time_send_email)
    end
end
