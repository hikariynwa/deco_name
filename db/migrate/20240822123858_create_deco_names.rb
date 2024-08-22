class CreateDecoNames < ActiveRecord::Migration[7.2]
  def change
    create_table :deco_names do |t|
      t.string :name

      t.timestamps
    end
  end
end
