require File.expand_path('../test_helper', __dir__)
require_dependency 'extra_notes/issues_helper_patch'

class ExtraNotesIssuesHelperPatchTest < ActiveSupport::TestCase
  class DummyProject
    def module_enabled?(name)
      name == :extra_notes
    end
  end

  class DummyIssue
    attr_reader :project

    def initialize(project)
      @project = project
    end
  end

  class DummyHelperWithEmptyTabs
    def issue_history_tabs
      []
    end

    include ExtraNotes::IssuesHelperPatch
  end

  class DummyHelperWithNotesTabs
    def issue_history_tabs
      [{ name: 'notes', label: 'Notes' }]
    end

    include ExtraNotes::IssuesHelperPatch
  end

  class DummyProjectDisabled
    def module_enabled?(name)
      false
    end
  end

  def setup
    @original_enabled_note_types = ExtraNotesHelper.singleton_method(:enabled_note_types)
    ExtraNotesHelper.define_singleton_method(:enabled_note_types) do
      [
        { 'id' => 'default', 'use_tab' => '1', 'enabled' => '1' },
        { 'id' => 'custom', 'use_tab' => '1', 'enabled' => '1' }
      ]
    end
  end

  def teardown
    ExtraNotesHelper.define_singleton_method(:enabled_note_types, @original_enabled_note_types)
  end

  test 'does not create nil gap when base tabs are empty' do
    helper = DummyHelperWithEmptyTabs.new
    helper.instance_variable_set(:@issue, DummyIssue.new(DummyProject.new))
    helper.instance_variable_set(:@journals, [Object.new])

    tabs = helper.issue_history_tabs

    assert_equal 2, tabs.size
    assert_equal 'extra_notes_default', tabs[0][:name]
    assert_equal 'extra_notes_custom', tabs[1][:name]
    assert_not_includes tabs, nil
  end

  test 'inserts extra notes tabs after notes tab when it exists' do
    helper = DummyHelperWithNotesTabs.new
    helper.instance_variable_set(:@issue, DummyIssue.new(DummyProject.new))
    helper.instance_variable_set(:@journals, [Object.new])

    tabs = helper.issue_history_tabs

    assert_equal 3, tabs.size
    assert_equal 'notes', tabs[0][:name]
    assert_equal 'extra_notes_default', tabs[1][:name]
    assert_equal 'extra_notes_custom', tabs[2][:name]
  end

  test 'does not add tabs when extra_notes module is disabled' do
    helper = DummyHelperWithEmptyTabs.new
    helper.instance_variable_set(:@issue, DummyIssue.new(DummyProjectDisabled.new))
    helper.instance_variable_set(:@journals, [Object.new])

    tabs = helper.issue_history_tabs

    assert_equal 0, tabs.size
  end

  test 'does not add tabs when journals are empty' do
    helper = DummyHelperWithEmptyTabs.new
    helper.instance_variable_set(:@issue, DummyIssue.new(DummyProject.new))
    helper.instance_variable_set(:@journals, [])

    tabs = helper.issue_history_tabs

    assert_equal 0, tabs.size
  end

  test 'does not add tabs with disabled use_tab setting' do
    ExtraNotesHelper.define_singleton_method(:enabled_note_types) do
      [{ 'id' => 'disabled', 'use_tab' => '0', 'enabled' => '1' }]
    end

    helper = DummyHelperWithEmptyTabs.new
    helper.instance_variable_set(:@issue, DummyIssue.new(DummyProject.new))
    helper.instance_variable_set(:@journals, [Object.new])

    tabs = helper.issue_history_tabs

    assert_equal 0, tabs.size
  end

  test 'extra notes tabs have correct tab properties' do
    helper = DummyHelperWithEmptyTabs.new
    helper.instance_variable_set(:@issue, DummyIssue.new(DummyProject.new))
    helper.instance_variable_set(:@journals, [Object.new])

    tabs = helper.issue_history_tabs

    extra_notes_tab = tabs.first
    assert_equal 'extra_notes_default', extra_notes_tab[:name]
    assert_equal :label_extra_notes, extra_notes_tab[:label]
    assert_includes extra_notes_tab[:onclick], 'showIssueHistory'
    assert_includes extra_notes_tab[:onclick], 'extra_notes_default'
  end
end
