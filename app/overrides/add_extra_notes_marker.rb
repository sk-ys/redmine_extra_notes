module AddExtraNotesMarker
  Deface::Override.new(
    virtual_path: 'issues/tabs/_history',
    name: 'add_extra_notes_marker',
    insert_top: ".journal-meta",
    partial: 'extra_notes/extra_notes_marker'
  )
end