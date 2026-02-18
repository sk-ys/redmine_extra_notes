module ExtraNotes
  module IssuesHelperPatch
    def self.included(base)
      base.class_eval do
        if method_defined?(:issue_history_tabs)
          def issue_history_tabs_with_extra_notes()
            tabs = issue_history_tabs_without_extra_notes()
            
            # Add an "Extra Notes" tab if there are any journals with extra attributes
            if @journals.present?
              has_extra_notes = @journals.any? { |journal| journal.extra_attribute.present? }
              if has_extra_notes
                tabs << {
                  name: 'extra_notes',
                  label: :label_extra_notes,
                  onclick: 'showIssueHistory("extra_notes", this.href)'
                }
              end
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
