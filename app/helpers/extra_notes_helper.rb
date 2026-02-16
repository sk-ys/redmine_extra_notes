module ExtraNotesHelper
  def render_extra_notes_marker(journal)
    render partial: 'extra_notes/extra_notes_marker', locals: { journal: journal }
  end
end