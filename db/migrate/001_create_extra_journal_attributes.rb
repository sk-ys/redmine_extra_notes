class CreateExtraJournalAttributes < ActiveRecord::Migration[5.2]
  def change
    create_table :extra_journal_attributes do |t|
      t.integer :journal_id, null: false
    end
    add_index :extra_journal_attributes, :journal_id, unique: true
  end
end
