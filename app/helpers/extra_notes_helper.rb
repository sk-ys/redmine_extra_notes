module ExtraNotesHelper
  def render_extra_notes_marker(journal)
    render partial: 'extra_notes/extra_notes_marker', locals: { journal: journal }
  end

  def self.note_types
    settings = Setting.plugin_redmine_extra_notes
    types = settings['note_types']
    if types.nil?
      # Legacy fallback: convert old flat settings to single note type
      [{
        'id' => 'default',
        'label' => settings['extra_notes_label'] || '[EXTRA]',
        'tab_label' => settings['tab_label'] || 'Extra notes',
        'use_tab' => settings['use_tab'] || '1',
        'enabled' => '1'
      }]
    elsif types.is_a?(Hash)
      types.sort_by { |k, _| k.to_i }.map { |_, v| v }
    else
      Array(types)
    end
  end

  def self.enabled_note_types
    note_types.select { |t| t['enabled'].to_s != '0' }
  end

  def self.find_note_type(id)
    note_types.find { |t| t['id'] == id }
  end
end
