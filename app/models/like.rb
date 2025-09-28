class Like < ApplicationRecord
  belongs_to :user
  belongs_to :post, counter_cache: true # counter_cacheを有効にする

  validates :user_id, uniqueness: { scope: :post_id }

end
