module ExtraNotes
  class ViewJournalsUpdateJsBottomHook < Redmine::Hook::ViewListener
    render_on :view_journals_update_js_bottom, partial: 'extra_notes/extra_notes_marker'
  end
end
