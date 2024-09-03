class AddImageMetadataToDecoNames < ActiveRecord::Migration[7.2]
  def change
    add_column :deco_names, :image_path, :string
  end
end
