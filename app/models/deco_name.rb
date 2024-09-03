class DecoName < ApplicationRecord
  after_create :add_name_to_image

  private

  def add_name_to_image
    symbols = ['†', 'x', '★', '§', '*', '=', '✙', '刹', '༻', '۞', 'փ', '༒', '¢', '⌘', '∮', '✧', '♃', '♆']
    random_symbol = symbols.sample
    decorated_name = "#{random_symbol}#{self.name}#{random_symbol}"

    # デバッグ用出力
    puts "Decorated name before escaping: #{decorated_name}"
    puts "Self.name: #{self.name}"

    escaped_name = decorated_name.gsub("'", "\\\\'")

    # デバッグ用出力
    puts "Decorated name after escaping: #{escaped_name}"

    # 文字数に応じて位置を調整
    text_length = self.name.length
    # 絵文字の位置を調整するためのオフセット（文字数に応じて変化）
    offset = text_length * 29  # 1文字あたり25ピクセル程度のオフセット

    # app/assets/imagesに保存された画像のパス
    image_paths = Dir[Rails.root.join('app/assets/images/*.png')]  # 例: PNGファイルをすべて取得
    random_image_path = image_paths.sample

    image = MiniMagick::Image.open(random_image_path)

    # 文字部分を表示させる
    image.combine_options do |c|
      c.gravity "center"
      c.pointsize "50"
      c.font "/usr/share/fonts/opentype/noto/NotoSansCJK-Regular.ttc"  # 日本語用フォント
      c.fill "white"
      c.draw "text 0,0 '#{self.name}'"
    end

    # 絵文字部分を描画
    image.combine_options do |c|
      c.gravity "center"
      c.pointsize "50"
      c.font "/usr/share/fonts/truetype/dejavu/DejaVuSans.ttf"  # 絵文字用フォント
      c.fill "white"
      c.draw "text -#{offset},0 '#{random_symbol}'"  # 左側に1つ目の絵文字を描画
      c.draw "text #{offset},0 '#{random_symbol}'"   # 右側に2つ目の絵文字を描画
    end

    # 生成された画像を保存するパス
    output_dir = Rails.root.join('public', 'generated_images')
    FileUtils.mkdir_p(output_dir) unless Dir.exist?(output_dir)
    output_file_name = "#{self.id}.png"
    output_path = output_dir.join(output_file_name)

    # 画像を保存
    image.write(output_path)

    # image_path をデータベースに保存
    self.update_column(:image_path, "generated_images/#{output_file_name}")
  end
end
