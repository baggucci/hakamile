# app/controllers/inquiries_controller.rb

class InquiriesController < ApplicationController
  def new
    @inquiry = Inquiry.new
  end

  def create
    @inquiry = Inquiry.new(inquiry_params)
    if @inquiry.save
      redirect_to inquiries_complete_path
    else
      render :new
    end
  end

  def show
  @inquiry = Inquiry.find(params[:id])
  end


  def complete
    # 送信完了ページを表示するだけのアクション
  end

  private

  def inquiry_params
    params.require(:inquiry).permit(:name, :email, :category, :message, :linkable_id, :linkable_type)
  end
end