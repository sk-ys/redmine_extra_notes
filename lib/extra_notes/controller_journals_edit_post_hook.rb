module ExtraNotes
  class ControllerJournalsEditPostHook < Redmine::Hook::Listener
    def controller_journals_edit_post(context={})
      journal = context[:journal]
      params = context[:params]
      
      return unless journal&.persisted?
      
      begin
        if params[:extra_note].present?
          journal.extra_attribute || journal.create_extra_attribute
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
