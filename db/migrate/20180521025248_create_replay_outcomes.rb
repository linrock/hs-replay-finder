class CreateReplayOutcomes < ActiveRecord::Migration[5.2]
  def change
    create_table :replay_outcomes do |t|
      t.jsonb :data
      t.timestamps
    end
  end
end
