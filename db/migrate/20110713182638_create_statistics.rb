class CreateStatistics < ActiveRecord::Migration
  def self.up
    create_table :statistics do |t|
      t.integer :subject_id
      t.string :semester
      t.integer :year
      t.text :content

      t.timestamps
    end
  end

  def self.down
    drop_table :statistics
  end
end
