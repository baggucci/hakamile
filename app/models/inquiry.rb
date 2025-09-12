# app/models/inquiry.rb

class Inquiry < ApplicationRecord
  # アソシエーション
  belongs_to :linkable, polymorphic: true, optional: true

  # バリデーション
  validates :name, presence: true
  validates :email, presence: true
  validates :category, presence: true
  validates :message, presence: true

  # enumの設定
  enum category: { opinion: 0, bug_report: 1, content_report: 2, other: 3 }
  # 意味: 0:ご意見, 1:不具合報告, 2:コンテンツ報告, 3:その他
  
  enum status: { pending: 0, processing: 1, resolved: 2 }
  # 意味: 0:未対応, 1:対応中, 2:対応済
  
end