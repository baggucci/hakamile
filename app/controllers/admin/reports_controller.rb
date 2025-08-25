# app/controllers/admin/reports_controller.rb

class Admin::ReportsController < Admin::BaseController
  def index
    # N+1問題を防ぐため、関連するユーザー情報も事前に読み込みます
    @reports = Report.all.includes(:reporter, :reported).order(created_at: :desc)
  end

  def show
    @report = Report.find(params[:id])
  end

  def update
    @report = Report.find(params[:id])
    if @report.update(report_params)
      redirect_to admin_report_path(@report), notice: '対応ステータスを更新しました。'
    else
      render :show
    end
  end

  private

  def report_params
    params.require(:report).permit(:status)
  end
end