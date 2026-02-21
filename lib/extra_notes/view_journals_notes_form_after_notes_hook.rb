module ExtraNotes
  class ViewJournalsNotesFormAfterNotesHook < Redmine::Hook::ViewListener
    def view_journals_notes_form_after_notes(context)
      journal = context[:journal]
      if User.current.allowed_to?(:edit_extra_notes, journal.issue.project)
        return context[:controller].send(:render_to_string, {
          partial: 'extra_notes/extra_notes_checkbox',
          locals: { journal: journal }
        })
      end
    end
  end
end
