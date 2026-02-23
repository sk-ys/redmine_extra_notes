module ExtraNotes
  class ControllerSettingsPluginAfterUpdateHook < Redmine::Hook::Listener
    def controller_settings_plugin_after_update(context = {})
      return unless context[:plugin]&.id == :redmine_extra_notes

      current_note_type_ids = ExtraNotesHelper.note_types.map { |t| t['id'] }
      ExtraJournalAttribute.where.not(note_type: current_note_type_ids).delete_all
    end
  end
end
