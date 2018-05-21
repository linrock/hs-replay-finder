class CreateReplayOutcomes < ActiveRecord::Migration[5.2]
  def change
    create_table :replay_outcomes do |t|
      t.string :hsreplay_id, null: false
      t.jsonb :data, null: false
      t.timestamps
    end
    add_index :replay_outcomes, :hsreplay_id, unique: true
  end
end
