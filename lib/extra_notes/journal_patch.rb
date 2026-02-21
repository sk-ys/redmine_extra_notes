module ExtraNotes
  module JournalPatch
    def self.included(base)
      base.has_one :extra_attribute,
          class_name: 'ExtraJournalAttribute',
          dependent: :destroy
    end
  end

  Journal.include JournalPatch
end
