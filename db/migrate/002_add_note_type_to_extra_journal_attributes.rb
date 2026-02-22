class AddNoteTypeToExtraJournalAttributes < ActiveRecord::Migration[5.2]
  def up
    add_column :extra_journal_attributes, :note_type, :string, null: false, default: 'default'
    remove_index :extra_journal_attributes, :journal_id
    add_index :extra_journal_attributes, [:journal_id, :note_type], unique: true
  end

  def down
    remove_index :extra_journal_attributes, [:journal_id, :note_type]
    remove_column :extra_journal_attributes, :note_type
    add_index :extra_journal_attributes, :journal_id, unique: true
  end
end
