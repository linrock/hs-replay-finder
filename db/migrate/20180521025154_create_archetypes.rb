class CreateArchetypes < ActiveRecord::Migration[5.2]
  def change
    create_table :archetypes do |t|
      t.jsonb :data, null: false
      t.timestamps
    end
  end
end
