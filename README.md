# Redmine Extra Notes

This Redmine plugin lets you manage issue notes as either normal or extra.
![](docs/images/image.png)

## Features

- Manage multiple extra note categories (each can be enabled/disabled).
- Choose a category from a dropdown when adding or editing a note.
- Each category has its own marker label and optional history tab label.
- Categories can be reordered in settings (drag and drop).
- History tabs can be enabled or disabled per category:
   - **Notes**: shows normal notes only.
   - **Extra Notes #N**: shows notes for that category only.

## Installation

1. Clone the repository into the plugins directory:

```bash
cd {REDMINE_ROOT}/plugins
git clone https://github.com/sk-ys/redmine_extra_notes.git
```

2. Run the database migration:

```bash
bundle exec rake redmine:plugins:migrate RAILS_ENV=production
```

3. Restart Redmine.

4. Set Permissions:
   - After installation, go to "Administration" > "Roles and permissions" in Redmine.
   - Edit each role that should use Extra Notes and enable the following permissions under the "Extra notes" section:
     - Add extra notes (`add_extra_notes`)
     - Edit extra notes (`edit_extra_notes`)
   - Only users with these permissions can add or edit extra notes on issues.
   - Edit permission

## Usage

### Permissions

- Add extra notes (`add_extra_notes`): Allows users to add extra notes to issues.
- Edit extra notes (`edit_extra_notes`): Allows users to edit extra notes on issues.

### Settings

- Add or remove categories in the plugin settings screen.
- Configure each category's marker label, tab label, tab usage, and enabled state.
- Reorder categories via drag and drop.

### How to use

1. Enable the "Extra notes" module for each project:
   - Go to the project settings in Redmine.
   - On the "Modules" tab, check "Extra notes" and save.
2. When adding or editing a note, choose a category from the Extra Notes dropdown (requires permission).
3. If enabled, select the matching "Extra Notes" tab to view notes for that category.
   - If a category's tab is disabled, those notes appear in the regular "Notes" tab.

## Uninstall

```bash
bundle exec rake redmine:plugins:migrate NAME=redmine_extra_notes VERSION=0 RAILS_ENV=production
```
