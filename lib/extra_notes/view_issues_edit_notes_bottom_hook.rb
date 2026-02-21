module ExtraNotes
  class ViewIssuesEditNotesBottomHook < Redmine::Hook::ViewListener
    def view_issues_edit_notes_bottom(context)
      issue = context[:issue]
      if issue && (User.current.allowed_to?(:add_extra_notes, issue.project) || User.current.allowed_to?(:edit_extra_notes, issue.project))
        return context[:controller].send(:render_to_string, {
          partial: 'extra_notes/extra_notes_checkbox',
          locals: { issue: issue }
        })
      end
    end
  end
end
