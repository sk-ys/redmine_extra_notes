module ExtraNotes
  module JournalPatch
    def self.included(base)
      base.has_many :extra_attributes,
          class_name: 'ExtraJournalAttribute',
          dependent: :destroy
    end
  end

  Journal.include JournalPatch
end
