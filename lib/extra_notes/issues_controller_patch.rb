module ExtraNotes
  module IssuesControllerPatch
    def self.included(base)
      base.after_action :save_extra_note, only: [:update]

      private

      def save_extra_note
        return unless params[:extra_note].is_a?(ActionController::Parameters) || params[:extra_note].is_a?(Hash)
        return unless User.current.allowed_to?(:add_extra_notes, @issue.project) || User.current.allowed_to?(:edit_extra_notes, @issue.project)

        last_journal = @issue.journals.last
        return unless last_journal

        extra_note_params = params[:extra_note]
        ExtraNotesHelper.enabled_note_types.each do |note_type|
          if extra_note_params[note_type['id']].present?
            last_journal.extra_attributes.find_or_create_by(note_type: note_type['id'])
          end
        end
      end
    end
  end
end

IssuesController.include ExtraNotes::IssuesControllerPatch
