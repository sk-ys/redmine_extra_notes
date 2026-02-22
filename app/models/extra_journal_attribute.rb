class ExtraJournalAttribute < ActiveRecord::Base
  belongs_to :journal
  validates :note_type, presence: true
end
