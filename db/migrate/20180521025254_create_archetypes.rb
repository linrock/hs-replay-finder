class CreateArchetypes < ActiveRecord::Migration[5.2]
  def change
    create_table :archetypes do |t|
      t.jsonb :data
      t.timestamps
    end
  end
end
