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
    # もしユーザーモデルに管理者権限を区別するカラム（例: admin:boolean）があれば、以下も追加
    # user.admin = true
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
#   先にジャンルオブジェクトを作成し、変数に格納しておく
# ----------------------------------------------------------------
puts 'ジャンルを作成中...'
genre_history = Genre.find_or_create_by!(name: '歴史上の人物')
genre_art = Genre.find_or_create_by!(name: '芸術家')
genre_science = Genre.find_or_create_by!(name: '科学者')
genre_shogun = Genre.find_or_create_by!(name: '武将')
genre_writer = Genre.find_or_create_by!(name: '文学者')
genre_meiji = Genre.find_or_create_by!(name: '明治維新') # "明治維新"もここで定義
puts 'ジャンルを作成しました。'


# ----------------------------------------------------------------
# ★ 墓所 (graves)
#   データ定義では、文字列ではなく上記で作成した「変数」を使う
# ----------------------------------------------------------------
puts '墓所を作成中...'
graves_data = [
  { name: '坂本龍馬', prefecture: '高知県', address: '高知市山の端', description: '幕末の志士、坂本龍馬の墓所。', latitude: 33.5713, longitude: 133.5385, genre_obj: genre_meiji },
  { name: '織田信長', prefecture: '京都府', address: '京都市上京区', description: '戦国時代の武将、織田信長の廟所。', latitude: 35.027, longitude: 135.755, genre_obj: genre_shogun },
  { name: '徳川家康', prefecture: '静岡県', address: '静岡市駿河区', description: '江戸幕府初代将軍、徳川家康の墓所。', latitude: 34.9756, longitude: 138.3828, genre_obj: genre_shogun },
  { name: '伊達政宗', prefecture: '宮城県', address: '仙台市青葉区', description: '仙台藩初代藩主、伊達政宗の霊屋。', latitude: 38.2575, longitude: 140.8679, genre_obj: genre_shogun },
  { name: '武田信玄', prefecture: '山梨県', address: '甲府市', description: '甲斐の戦国大名、武田信玄の墓所。', latitude: 35.662, longitude: 138.5684, genre_obj: genre_shogun },
  { name: '上杉謙信', prefecture: '新潟県', address: '上越市', description: '越後の戦国大名、上杉謙信の墓所。', latitude: 37.1069, longitude: 138.2435, genre_obj: genre_shogun },
  { name: '豊臣秀吉', prefecture: '京都府', address: '京都市東山区', description: '安土桃山時代の武将、豊臣秀吉の廟所。', latitude: 34.9942, longitude: 135.7788, genre_obj: genre_shogun },
  { name: '宮本武蔵', prefecture: '熊本県', address: '熊本市中央区', description: '江戸時代初期の剣術家、宮本武蔵の墓。', latitude: 32.8032, longitude: 130.7079, genre_obj: genre_history },
  { name: '西郷隆盛', prefecture: '鹿児島県', address: '鹿児島市', description: '明治維新の指導者、西郷隆盛の墓。', latitude: 31.5964, longitude: 130.5543, genre_obj: genre_meiji },
  { name: '吉田松陰', prefecture: '東京都', address: '世田谷区', description: '幕末の思想家、吉田松陰の墓。', latitude: 35.6623, longitude: 139.6646, genre_obj: genre_meiji }
]

graves_data.each do |data|
  grave = Grave.find_or_create_by!(name: data[:name]) do |g|
    g.prefecture = data[:prefecture]
    g.address = data[:address]
    g.description = data[:description]
    g.latitude = data[:latitude]
    g.longitude = data[:longitude]
  end
  # 中間テーブルには、dataハッシュから取り出したgenreオブジェクトを渡す
  GraveGenre.find_or_create_by!(grave: grave, genre: data[:genre_obj])
end
puts '墓所を作成しました。'


# ゲストユーザーの作成
User.guest
puts "ゲストユーザーを作成しました" # 実行確認用に追記


puts '全てのseedデータの投入が完了しました。'