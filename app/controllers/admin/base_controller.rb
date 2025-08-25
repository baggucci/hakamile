class Admin::BaseController < ApplicationController
    # 管理者としてログインしているかを確認する
    before_action :authenticate_admin!
  end