# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

# db/seeds.rb

Admin.find_or_create_by!(email: 'admin@example.com') do |admin|
    admin.password = ENV['ADMIN_PASSWORD']
    admin.password_confirmation = ENV['ADMIN_PASSWORD']
  end
  
  puts "管理者ユーザーの作成が完了しました"


  # 1. 一般ユーザーのサンプルデータ
User.find_or_create_by!(email: 'test-user@example.com') do |user|
    user.name = 'テストユーザー'
    user.password = 'password'
    user.password_confirmation = 'password'
    user.profile = 'これはテストユーザーです。よろしくお願いします。'
  end
puts "ユーザーの初期データ作成が完了しました。"

# ----------------------------------------------------------------
# ★ ジャンル (genres)
# ----------------------------------------------------------------
puts 'ジャンルを作成中...'
genre_history = Genre.find_or_create_by!(name: '歴史上の人物')
genre_art = Genre.find_or_create_by!(name: '芸術家')
genre_science = Genre.find_or_create_by!(name: '科学者')
genre_shogun = Genre.find_or_create_by!(name: '武将')
genre_writer = Genre.find_or_create_by!(name: '文学者')
genre_meiji = Genre.find_or_create_by!(name: '明治維新') 
puts 'ジャンルを作成しました。'


# ----------------------------------------------------------------
# ★ 墓所 (graves)
# ----------------------------------------------------------------
puts '墓所を作成中...'
graves_data = [
  { name: '坂本龍馬', prefecture: '京都府', address: '京都市東山区', description: '幕末の志士、坂本龍馬の墓所', latitude: 35.0086, longitude: 135.7828, genre_obj: genre_meiji, image_filename: 'sakamoto_ryoma.jpg' },
  { name: '織田信長', prefecture: '京都府', address: '京都市上京区', description: '戦国時代の武将、織田信長の廟所。', latitude: 35.027, longitude: 135.755, genre_obj: genre_shogun, image_filename: 'oda_nobunaga.jpg' },
  { name: '徳川家康', prefecture: '静岡県', address: '静岡市駿河区', description: '江戸幕府初代将軍、徳川家康の墓所。', latitude: 34.9550, longitude: 138.4585, genre_obj: genre_shogun, image_filename: 'tokugawa_ieyasu.jpg' },
  { name: '伊達政宗', prefecture: '宮城県', address: '仙台市青葉区', description: '仙台藩初代藩主、伊達政宗の霊屋。', latitude: 38.2575, longitude: 140.8679, genre_obj: genre_shogun, image_filename: 'date_masamune.jpg' },
  { name: '武田信玄', prefecture: '山梨県', address: '甲府市', description: '甲斐の戦国大名、武田信玄の墓所。', latitude: 35.662, longitude: 138.5684, genre_obj: genre_shogun, image_filename: 'takeda_shingen.jpg' },
  { name: '上杉謙信', prefecture: '新潟県', address: '上越市', description: '越後の戦国大名、上杉謙信の墓所。', latitude: 37.1069, longitude: 138.2435, genre_obj: genre_shogun, image_filename: 'uesugi_kenshin.jpg' },
  { name: '豊臣秀吉', prefecture: '京都府', address: '京都市東山区', description: '安土桃山時代の武将、豊臣秀吉の廟所。', latitude: 34.9942, longitude: 135.7788, genre_obj: genre_shogun, image_filename: 'toyotomi_hideyoshi.jpg' },
  { name: '宮本武蔵', prefecture: '熊本県', address: '熊本市中央区', description: '江戸時代初期の剣術家、宮本武蔵の墓。', latitude: 32.8032, longitude: 130.7079, genre_obj: genre_history, image_filename: 'miyamoto_musashi.jpg' },
  { name: '西郷隆盛', prefecture: '鹿児島県', address: '鹿児島市', description: '明治維新の指導者、西郷隆盛の墓。', latitude: 31.5964, longitude: 130.5543, genre_obj: genre_meiji, image_filename: 'saigo_takamori.jpg' },
  { name: '吉田松陰', prefecture: '東京都', address: '世田谷区', description: '幕末の思想家、吉田松陰の墓。', latitude: 35.6623, longitude: 139.6646, genre_obj: genre_meiji, image_filename: 'yoshida_shoin.jpg' }
]

graves_data.each do |data|
  grave = Grave.find_or_create_by!(name: data[:name]) do |g|
    g.prefecture = data[:prefecture]
    g.address = data[:address]
    g.description = data[:description]
    g.latitude = data[:latitude]
    g.longitude = data[:longitude]
  end
  
  # 中間テーブルの処理
  GraveGenre.find_or_create_by!(grave: grave, genre: data[:genre_obj])
  
  # 画像がまだ添付されていない場合のみ、処理を実行する
  unless grave.main_image.attached?
    # 画像ファイルのフルパスを取得
    image_path = Rails.root.join('db', 'seed_images', data[:image_filename])
    
    # ファイルが存在するか確認
    if File.exist?(image_path)
      # ファイルを開いて画像を添付
      grave.main_image.attach(
        io: File.open(image_path),
        filename: data[:image_filename],
        content_type: 'image/jpeg' # 画像の形式に合わせて変更してください
      )
    else
      puts "画像ファイルが見つかりません: #{image_path}"
    end
  end
end
puts '墓所を作成しました。'


# ゲストユーザーの作成
User.guest
puts "ゲストユーザーを作成しました" 

# ----------------------------------------------------------------
# ★ 投稿 (posts)　　←　ここから追記
# ----------------------------------------------------------------
puts '投稿を作成中...'

# 投稿で使用するユーザーと墓所をデータベースから取得
# (既に上で取得している場合はそれを再利用するか、再度取得する)
test_user = User.find_by(email: 'test-user@example.com')

ryoma_grave = Grave.find_by(name: '坂本龍馬')
nobunaga_grave = Grave.find_by(name: '織田信長')
ieyasu_grave = Grave.find_by(name: '徳川家康')

posts_data = [
  {
    user: test_user,
    grave: ryoma_grave,
    title: '龍馬さんに会いに京都へ！',
    body: "今日は念願だった坂本龍馬さんのお墓参りに行った。京都の霊山護国神社の霊山墓地まで足を運び、入場料300円を自動販売機で購入してゲートを通る。石段を登りながら、幕末の志士たちが眠るこの聖地への敬意で胸がいっぱいになった。\n龍馬さんと中岡慎太郎さんの墓が並んで建っているのを見て、近江屋で共に倒れた二人の友情を思い出し、思わず涙が込み上げてきた。墓石の前で手を合わせ、「現代の日本を見て、どう思われますか」と心の中で問いかけた。風が頬を撫ていき、龍馬さんからの返事のように感じられた。\n幕末の動乱を駆け抜けた31年の生涯に思いを馳せながら、私も精一杯生きようと決意を新たにした。また必ず参らせていただきます。",
    status: :published, # 公開ステータスを想定
    likes_count: 15,
    created_at: Time.zone.parse('2025-09-29 12:19:00'),
    image_filenames: ['ryoma_grave_image1.jpg', 'ryoma_grave_image2.jpg', 'ryoma_grave_image3.jpg']
  },
  {
    user: test_user,
    grave: nobunaga_grave,
    title: '天下布武の夢、織田信長公の廟所',
    body: '安土城の面影を追い、織田信長公の廟所を訪れました。あの本能寺の変から400年以上経った今も、その存在感は圧倒的です。彼の天下布武の夢に思いを馳せ、日本の歴史の転換点を感じることができました。',
    status: :published,
    likes_count: 8,
    created_at: Time.current.ago(10.days),
    image_filenames: ['nobunaga_grave_image1.jpg', 'nobunaga_grave_image2.jpg']
  },
  {
    user: test_user,
    grave: ieyasu_grave,
    title: '徳川家康公が眠る久能山東照宮',
    body: '徳川家康公が眠る久能山東照宮へ。この地から天下泰平の世が築かれたのかと思うと、胸が熱くなります。石段を登りながら、歴史の重みを感じることができました。',
    status: :published,
    likes_count: 10,
    created_at: Time.current.ago(7.days),
    image_filenames: ['ieyasu_grave_image1.jpg']
  }
]

posts_data.each do |data|
  # ユーザーか墓所が見つからない場合は、この投稿の作成をスキップ
  next unless data[:user] && data[:grave]

  post = Post.find_or_create_by!(
    user: data[:user],
    grave: data[:grave],
    title: data[:title]
  ) do |p|
    p.body = data[:body]
    p.status = data[:status]
    p.likes_count = data[:likes_count]
    p.created_at = data[:created_at] if data[:created_at]
  end

  # 画像の添付
  if post.images.empty? && data[:image_filenames].present?
    data[:image_filenames].each do |filename|
      image_path = Rails.root.join('db', 'seed_images', filename)
      if File.exist?(image_path)
        post.images.attach(
          io: File.open(image_path),
          filename: filename,
          content_type: 'image/jpeg'
        )
        puts "  投稿 '#{post.title}' に画像 '#{filename}' を添付しました。"
      else
        puts "  投稿 '#{post.title}' の画像ファイルが見つかりません: #{image_path}"
      end
    end
  end
end 

puts '投稿を作成しました。'

puts '全てのseedデータの投入が完了しました。'
