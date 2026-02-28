module ExtraNotesHelper
  def render_extra_notes_label(journal)
    render partial: 'extra_notes/extra_notes_label', locals: { journal: journal }
  end

  def self.note_types
    settings = Setting.plugin_redmine_extra_notes
    types = settings['note_types']

    raw_types =
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

    Array(raw_types).map { |t| normalize_note_type(t, settings) }.compact
  end

  def self.normalize_note_type(type, settings)
    return nil unless type.is_a?(Hash)

    defaults = {
      'id' => 'default',
      'label' => settings['extra_notes_label'] || '[EXTRA]',
      'tab_label' => settings['tab_label'] || 'Extra notes',
      'use_tab' => settings['use_tab'] || '1',
      'enabled' => '1'
    }

    normalized = defaults.merge(type)

    # Ensure boolean-like fields are normalized to "0" or "1" strings
    normalized['use_tab'] = normalized['use_tab'].to_s == '0' ? '0' : '1'
    normalized['enabled'] = normalized['enabled'].to_s == '0' ? '0' : '1'

    normalized
  end
  def self.enabled_note_types
    note_types.select { |t| t['enabled'].to_s != '0' }
  end

  def self.find_note_type(id)
    note_types.each_with_index do |t, i|
      return t.merge('order' => i + 1) if t['id'] == id
    end
    nil
  end
end
