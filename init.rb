Redmine::Plugin.register :redmine_extra_notes do
  name 'Redmine Extra Notes'
  author 'sk-ys'
  version '0.0.2'
  url 'http://github.com/sk-ys/redmine_extra_notes'
  author_url 'http://github.com/sk-ys'

  settings default: { 'use_tab' => '1', 'tab_label' => '', 'extra_notes_label' => '[EXTRA]' },
    partial: 'settings/extra_notes_settings'
end

$LOAD_PATH.unshift File.expand_path(File.dirname(__FILE__) + '/lib')
Rails.configuration.after_initialize do
  require_dependency 'journal'
  require_dependency 'issues_controller'
  require_dependency 'issues_helper'
  require_dependency 'extra_notes/journal_patch'
  require_dependency 'extra_notes/issues_controller_patch'
  require_dependency 'extra_notes/issues_helper_patch'
  require_dependency 'extra_notes/controller_journals_edit_post_hook'
  require_dependency 'extra_notes/view_issues_show_details_bottom_hook'
  require_dependency 'extra_notes/view_issues_edit_notes_bottom_hook'
  require_dependency 'extra_notes/view_journals_notes_form_after_notes_hook'
  require_dependency 'extra_notes/view_journals_update_js_bottom_hook'
end
