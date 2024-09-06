class DecoName < ApplicationRecord
  after_create :add_name_to_image

  private

  def add_name_to_image
    symbols = ['†', 'x', '★', '§', '*', '=', '✙', '¢', '∮', '✧', '♃', '♆']
    random_symbol = symbols.sample
    decorated_name = "#{random_symbol}#{self.name}#{random_symbol}"

    # デバッグ用出力,後で消す
    puts "Decorated name before escaping: #{decorated_name}"
    puts "Self.name: #{self.name}"

    escaped_name = decorated_name.gsub("'", "\\\\'")

    # デバッグ用出力
    puts "Decorated name after escaping: #{escaped_name}"

    # 文字数に応じて位置を調整する。
    text_length = self.name.length

    offset = text_length * 29  # 1文字あたり25ピクセル程度のオフセットらしい。

    # app/assets/imagesに保存された画像のパス
    image_paths = Dir[Rails.root.join('app/assets/images/*.png')]  # 画像の取得
    random_image_path = image_paths.sample

    image = MiniMagick::Image.open(random_image_path)

    # MiniMagick::Tool::Mogrifyを使って文字部分を描画
    MiniMagick::Tool::Mogrify.new do |mogrify|
      mogrify.gravity "center"
      mogrify.pointsize "50"
      mogrify.font "/usr/share/fonts/opentype/noto/NotoSansCJK-Regular.ttc"
      mogrify.fill "white"
      mogrify.draw "text 0,0 '#{self.name}'"
      mogrify << image.path
    end

    # 絵文字部分を描画
    MiniMagick::Tool::Mogrify.new do |mogrify|
      mogrify.gravity "center"
      mogrify.pointsize "50"
      mogrify.font "/usr/share/fonts/truetype/noto/NotoSansSymbols-Regular.ttf"
      mogrify.fill "white"
      mogrify.draw "text -#{offset},0 '#{random_symbol}'"  # 左側に絵文字
      mogrify.draw "text #{offset},0 '#{random_symbol}'"   # 右側に絵文字
      mogrify << image.path
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
