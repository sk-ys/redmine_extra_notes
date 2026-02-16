module ExtraNotes
  module IssuesControllerPatch
    def self.included(base)
      base.after_action :save_extra_note, only: [:update]

      private

      def save_extra_note
        return unless params[:extra_note].present?

        last_journal = @issue.journals.last
        return unless last_journal
        
        ExtraJournalAttribute.create(journal: last_journal)
      end
    end
  end
end

IssuesController.include ExtraNotes::IssuesControllerPatch
