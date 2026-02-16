module ExtraNotes
  class ViewJournalsNotesFormAfterNotesHook < Redmine::Hook::ViewListener
    render_on :view_journals_notes_form_after_notes, partial: 'extra_notes/extra_notes_checkbox'
  end
end
