# app/controllers/admin/inquiries_controller.rb
class Admin::InquiriesController < Admin::BaseController
  def index
    # includesでN+1問題を解消
    @inquiries = Inquiry.all.order(created_at: :desc)
  end

  def show
    @inquiry = Inquiry.find(params[:id])
  end

  def update
    @inquiry = Inquiry.find(params[:id])
    if @inquiry.update(inquiry_params)
      redirect_to admin_inquiry_path(@inquiry), notice: '対応ステータスを更新しました。'
    else
      render :show
    end
  end

  private

  def inquiry_params
    params.require(:inquiry).permit(:status)
  end
end