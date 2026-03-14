module ExtraNotes
  module IssuesHelperPatch
    def self.included(base)
      base.class_eval do
        if method_defined?(:issue_history_tabs)
          def issue_history_tabs_with_extra_notes()
            tabs = issue_history_tabs_without_extra_notes()

            return tabs unless @issue.project.module_enabled?(:extra_notes) && @journals.present?

            tab_types = ExtraNotesHelper.enabled_note_types.select { |t| t['use_tab'].to_s != '0' }
            return tabs if tab_types.empty?

            notes_index = tabs.find_index { |tab| tab[:name] == 'notes' }
            insert_position = notes_index ? notes_index + 1 : tabs.size
            offset = 0

            tab_types.each do |note_type|
              tab_name = "extra_notes_#{ExtraNotesHelper.effective_key(note_type)}"
              tabs.insert(insert_position + offset, {
                name: tab_name,
                label: :label_extra_notes,
                onclick: "showIssueHistory(\"#{tab_name}\", this.href)"
              })
              offset += 1
            end

            tabs
          end

          alias_method :issue_history_tabs_without_extra_notes, :issue_history_tabs
          alias_method :issue_history_tabs, :issue_history_tabs_with_extra_notes
        end
      end
    end
  end
end

IssuesHelper.include ExtraNotes::IssuesHelperPatch if defined?(IssuesHelper)
