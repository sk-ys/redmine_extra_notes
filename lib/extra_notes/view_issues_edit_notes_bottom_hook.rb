module ExtraNotes
  class ViewIssuesEditNotesBottomHook < Redmine::Hook::ViewListener
    render_on :view_issues_edit_notes_bottom, partial: 'extra_notes/extra_notes_checkbox'
  end
end
