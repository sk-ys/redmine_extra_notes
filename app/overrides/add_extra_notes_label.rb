module AddExtraNotesLabel
  Deface::Override.new(
    virtual_path: 'issues/tabs/_history',
    name: 'add_extra_notes_label',
    insert_top: ".journal-meta",
    partial: 'extra_notes/extra_notes_label'
  )
end