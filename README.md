# Redmine Extra Notes

This Redmine plugin lets you manage issue notes as either normal or extra.
![](docs/images/image.png)

## Features

- When adding a note, use the "Extra Notes" checkbox to mark it as extra.
- Extra notes show the `[EXTRA]` label by default.
- The label for extra notes is customizable in the plugin settings.
- Updates the issue history tab behavior:
  - **Notes**: shows normal notes only.
  - **Extra Notes**: shows extra notes only.
  - This tab can be enabled or disabled in the plugin settings.

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

### How to use

1. Enable the "Extra notes" module for each project:
   - Go to the project settings in Redmine.
   - On the "Modules" tab, check "Extra notes" and save.
2. When adding a note, check "Extra Notes" to save it as an Extra note (requires permission).
3. If enabled, select the "Extra Notes" tab to view extra notes.
   - (If the tab is disabled, extra notes will appear in the regular "Notes" tab as usual.)

## Uninstall

```bash
bundle exec rake redmine:plugins:migrate NAME=redmine_extra_notes VERSION=0 RAILS_ENV=production
```
