module ExtraNotes
  class ViewIssuesShowDetailsBottomHook < Redmine::Hook::ViewListener
    render_on :view_issues_show_details_bottom, partial: 'extra_notes/show_details_bottom'
  end
end
