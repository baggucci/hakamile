class HomesController < ApplicationController
  def index
    # 安全な方法でデータを取得
    begin
      @recent_posts = Post.includes(:user, :grave).order(created_at: :desc).limit(4)
    rescue
      @recent_posts = []
    end
    
    @popular_categories = [
      { name: '文学者', icon: 'fas fa-feather', count: 2341, slug: 'literature' },
      { name: '芸能人', icon: 'fas fa-masks-theater', count: 1876, slug: 'entertainment' },
      { name: '政治家', icon: 'fas fa-landmark', count: 1234, slug: 'politics' },
      { name: 'スポーツ選手', icon: 'fas fa-running', count: 987, slug: 'sports' }
    ]
  end
  
  def top
    # topアクションも同様に処理
    begin
      @recent_posts = Post.includes(:user, :grave).order(created_at: :desc).limit(4)
    rescue
      @recent_posts = []
    end
    
    @popular_categories = [
      { name: '文学者', icon: 'fas fa-feather', count: 2341, slug: 'literature' },
      { name: '芸能人', icon: 'fas fa-masks-theater', count: 1876, slug: 'entertainment' },
      { name: '政治家', icon: 'fas fa-landmark', count: 1234, slug: 'politics' },
      { name: 'スポーツ選手', icon: 'fas fa-running', count: 987, slug: 'sports' }
    ]
  end
end