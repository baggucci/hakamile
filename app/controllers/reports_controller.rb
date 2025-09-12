class ReportsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_grave

  def new
    @report = Report.new
  end

  def create
    @report = Report.new(report_params)
    @report.reporter = current_user       # 通報者
    @report.reportable = @grave           # 通報対象（墓所そのもの）

    if @report.save
      # リダイレクト先とメッセージを修正
      redirect_to @grave, notice: 'この墓所の情報を管理者へ報告しました。ご協力ありがとうございます。'
    else
      flash.now[:alert] = '報告に失敗しました。'
      render :new
    end
  end

  private

  # メソッド名を変更し、params[:grave_id]で探すように修正
  def set_grave
    @grave = Grave.find(params[:grave_id])
  end

  def report_params
    params.require(:report).permit(:reason, :note)
  end
end