module ExtraNotes
  module IssuesControllerPatch
    def self.included(base)
      base.after_action :save_extra_note, only: [:update]
      base.send(:private, :save_extra_note)
    end

    private

    def save_extra_note
      return unless params.key?(:extra_note_type)
      return unless User.current.allowed_to?(:add_extra_notes, @issue.project) || User.current.allowed_to?(:edit_extra_notes, @issue.project)

      last_journal = @issue.journals.last
      return unless last_journal

      note_type_id = params[:extra_note_type].presence
      if note_type_id && ExtraNotesHelper.enabled_note_types.any? { |t| t['id'] == note_type_id }
        attr = ExtraJournalAttribute.find_or_initialize_by(journal_id: last_journal.id)
        attr.note_type = note_type_id
        attr.save!
      else
        last_journal.extra_attribute&.destroy
      end
    end
  end
end

IssuesController.include ExtraNotes::IssuesControllerPatch
