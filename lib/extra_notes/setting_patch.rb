module ExtraNotes
  module SettingPatch
    def self.included(base)
      base.after_commit :sync_extra_journal_attributes, on: [:create, :update]
    end

    private

    def sync_extra_journal_attributes
      return unless name == 'plugin_redmine_extra_notes'
      return unless saved_change_to_value?

      old_val, new_val = saved_change_to_value

      # Note types are stored with numeric string keys ("0", "1", …) and sorted
      # numerically so that position in the list is used to match old vs new entries.
      old_types = extract_note_types_from_value(old_val)
      new_types = extract_note_types_from_value(new_val)

      # Build a map of old_id => new_id for every position where the ID changed.
      rename_map = {}
      [old_types.length, new_types.length].min.times do |i|
        old_id = old_types[i]['id'].to_s.strip
        new_id = new_types[i]['id'].to_s.strip
        next if old_id == new_id || old_id.empty? || new_id.empty?

        rename_map[old_id] = new_id
      end

      # Apply all renames in a single SQL statement to avoid cascade conflicts
      # (e.g. A→B and B→C applied sequentially would incorrectly move A records to C).
      unless rename_map.empty?
        conn = ExtraJournalAttribute.connection
        cases = rename_map.map do |old_id, new_id|
          "WHEN #{conn.quote(old_id)} THEN #{conn.quote(new_id)}"
        end.join(' ')
        ExtraJournalAttribute
          .where(note_type: rename_map.keys)
          .update_all("note_type = CASE note_type #{cases} END")
      end

      # Remove records whose note type no longer exists
      current_note_type_ids = ExtraNotesHelper.note_types.map { |t| t['id'] }
      ExtraJournalAttribute.where.not(note_type: current_note_type_ids).delete_all
    end

    def extract_note_types_from_value(setting_value)
      return [] unless setting_value.is_a?(Hash)

      types = setting_value['note_types']
      return [] unless types.is_a?(Hash)

      # Keys are numeric strings ("0", "1", …); sort numerically to preserve order.
      types.sort_by { |k, _| k.to_i }.map { |_, v| v }.select { |t| t.is_a?(Hash) }
    end
  end
end

Setting.include ExtraNotes::SettingPatch
