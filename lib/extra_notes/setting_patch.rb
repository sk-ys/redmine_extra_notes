module ExtraNotes
  module SettingPatch
    def self.included(base)
      base.after_commit :delete_orphaned_extra_journal_attributes, on: [:create, :update]
    end

    private

    def delete_orphaned_extra_journal_attributes
      return unless name == 'plugin_redmine_extra_notes'
      return unless saved_change_to_value?

      current_note_type_ids = ExtraNotesHelper.note_types.map { |t| t['id'] }
      ExtraJournalAttribute.where.not(note_type: current_note_type_ids).delete_all
    end
  end
end

Setting.include ExtraNotes::SettingPatch
