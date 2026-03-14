module ExtraNotes
  module SettingPatch
    def self.included(base)
      base.after_commit :delete_orphaned_extra_journal_attributes, on: [:create, :update]
      base.before_validation :validate_note_type_key_uniqueness
    end

    private

    def validate_note_type_key_uniqueness
      return unless name == 'plugin_redmine_extra_notes'

      # Read note types directly from the value being saved (not from the DB)
      settings = value.is_a?(Hash) ? value : {}
      types_raw = settings['note_types']

      raw_list =
        if types_raw.is_a?(Hash)
          types_raw.sort_by { |k, _| k.to_i }.map { |_, v| v }
        elsif types_raw.is_a?(Array)
          types_raw
        else
          []
        end

      types = raw_list.select { |t| t.is_a?(Hash) }

      unless ExtraNotesHelper.note_type_keys_unique?(types)
        errors.add(:value, :note_type_keys_not_unique)
        throw :abort
      end
    end

    def delete_orphaned_extra_journal_attributes
      return unless name == 'plugin_redmine_extra_notes'
      return unless saved_change_to_value?

      current_note_type_ids = ExtraNotesHelper.note_types.map { |t| t['id'] }
      ExtraJournalAttribute.where.not(note_type: current_note_type_ids).delete_all
    end
  end
end

Setting.include ExtraNotes::SettingPatch
