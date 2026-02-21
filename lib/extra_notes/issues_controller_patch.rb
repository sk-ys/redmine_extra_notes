module ExtraNotes
  module IssuesControllerPatch
    def self.included(base)
      base.after_action :save_extra_note, only: [:update]

      private

      def save_extra_note
        return unless params[:extra_note].present?
        return unless User.current.allowed_to?(:add_extra_notes, @issue.project) || User.current.allowed_to?(:edit_extra_notes, @issue.project)

        last_journal = @issue.journals.last
        return unless last_journal
        
        ExtraJournalAttribute.create(journal: last_journal)
      end
    end
  end
end

IssuesController.include ExtraNotes::IssuesControllerPatch
