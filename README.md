# Redmine Extra Notes

This Redmine plugin lets you manage issue comments as either normal or Extra.

## Features

- When adding a comment, use the "Extra Note" checkbox to mark it as Extra.
- Extra comments show the [EXTRA] tag.
- Update issue history tabs behavior:
  - **Notes**: normal notes only.
  - **Extra Notes**: Extra notes only.

## Installation

1. Clone into the plugins directory:
```bash
cd {REDMINE_ROOT}/plugins
git clone https://github.com/sk-ys/redmine_extra_notes.git
```

2. Run the database migration:
```bash
bundle exec rake redmine:plugins:migrate RAILS_ENV=production
```

3. Restart Redmine.

## Usage

1. When adding a comment, check "Extra Note" to save it as an Extra comment.
2. Switch between the "History" and "Extra" tabs on the issue page.

## Uninstall

```bash
bundle exec rake redmine:plugins:migrate NAME=redmine_extra_notes VERSION=0 RAILS_ENV=production
```
