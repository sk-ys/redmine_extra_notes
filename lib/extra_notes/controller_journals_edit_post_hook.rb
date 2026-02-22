module ExtraNotes
  class ControllerJournalsEditPostHook < Redmine::Hook::Listener
    def controller_journals_edit_post(context={})
      journal = context[:journal]
      params = context[:params]

      return unless journal&.persisted?
      return unless User.current.allowed_to?(:edit_extra_notes, journal.issue.project)

      begin
        note_type_id = params[:extra_note_type].presence
        if note_type_id && ExtraNotesHelper.enabled_note_types.any? { |t| t['id'] == note_type_id }
          attr = ExtraJournalAttribute.find_or_initialize_by(journal_id: journal.id)
          attr.note_type = note_type_id
          attr.save!
        else
          journal.extra_attribute&.destroy
        end

        # Refresh associations so JS hooks see the latest extra_attribute state.
        journal.reload
      rescue ActiveRecord::RecordInvalid => e
        Rails.logger.error "Failed to save extra note: #{e.message}"
      end
    end
  end
end
