module ExtraNotes
  class ControllerJournalsEditPostHook < Redmine::Hook::Listener
    def controller_journals_edit_post(context={})
      journal = context[:journal]
      params = context[:params]

      return unless journal&.persisted?
      return unless User.current.allowed_to?(:edit_extra_notes, journal.issue.project)

      extra_note_params = params[:extra_note] || {}

      begin
        ExtraNotesHelper.enabled_note_types.each do |note_type|
          if extra_note_params[note_type['id']].present?
            journal.extra_attributes.find_or_create_by(note_type: note_type['id'])
          else
            journal.extra_attributes.where(note_type: note_type['id']).destroy_all
          end
        end

        # Refresh associations so JS hooks see the latest extra_attribute state.
        journal.reload
      rescue ActiveRecord::RecordInvalid => e
        Rails.logger.error "Failed to save extra note: #{e.message}"
      end
    end
  end
end
