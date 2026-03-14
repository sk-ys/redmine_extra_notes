require File.expand_path('../test_helper', __dir__)

class ExtraNotesHelperTest < ActiveSupport::TestCase
  # ---------------------------------------------------------------------------
  # effective_key
  # ---------------------------------------------------------------------------

  test 'effective_key returns key when key is present' do
    note_type = { 'id' => 'default', 'key' => 'my_key' }
    assert_equal 'my_key', ExtraNotesHelper.effective_key(note_type)
  end

  test 'effective_key returns id when key is absent' do
    note_type = { 'id' => 'default' }
    assert_equal 'default', ExtraNotesHelper.effective_key(note_type)
  end

  test 'effective_key returns id when key is blank' do
    note_type = { 'id' => 'default', 'key' => '' }
    assert_equal 'default', ExtraNotesHelper.effective_key(note_type)
  end

  test 'effective_key returns id when key is whitespace only' do
    note_type = { 'id' => 'default', 'key' => '   ' }
    assert_equal 'default', ExtraNotesHelper.effective_key(note_type)
  end

  # ---------------------------------------------------------------------------
  # note_type_keys_unique?
  # ---------------------------------------------------------------------------

  test 'note_type_keys_unique? returns true for types with unique ids and no keys' do
    types = [
      { 'id' => 'default' },
      { 'id' => 'custom' }
    ]
    assert ExtraNotesHelper.note_type_keys_unique?(types)
  end

  test 'note_type_keys_unique? returns true for types with unique ids and unique keys' do
    types = [
      { 'id' => 'default', 'key' => 'key_a' },
      { 'id' => 'custom',  'key' => 'key_b' }
    ]
    assert ExtraNotesHelper.note_type_keys_unique?(types)
  end

  test 'note_type_keys_unique? returns false for duplicate ids' do
    types = [
      { 'id' => 'default' },
      { 'id' => 'default' }
    ]
    assert_not ExtraNotesHelper.note_type_keys_unique?(types)
  end

  test 'note_type_keys_unique? returns false for duplicate keys' do
    types = [
      { 'id' => 'default', 'key' => 'shared' },
      { 'id' => 'custom',  'key' => 'shared' }
    ]
    assert_not ExtraNotesHelper.note_type_keys_unique?(types)
  end

  test 'note_type_keys_unique? returns false when a key matches another types id' do
    types = [
      { 'id' => 'default' },
      { 'id' => 'custom', 'key' => 'default' }
    ]
    assert_not ExtraNotesHelper.note_type_keys_unique?(types)
  end

  test 'note_type_keys_unique? returns false when an id matches another types key' do
    types = [
      { 'id' => 'default', 'key' => 'custom' },
      { 'id' => 'custom' }
    ]
    assert_not ExtraNotesHelper.note_type_keys_unique?(types)
  end

  test 'note_type_keys_unique? ignores blank keys' do
    types = [
      { 'id' => 'default', 'key' => '' },
      { 'id' => 'custom',  'key' => '' }
    ]
    assert ExtraNotesHelper.note_type_keys_unique?(types)
  end

  # ---------------------------------------------------------------------------
  # normalize_note_type: key field
  # ---------------------------------------------------------------------------

  test 'normalize_note_type strips whitespace from key' do
    settings = {}
    result = ExtraNotesHelper.normalize_note_type({ 'id' => 'x', 'key' => '  my_key  ' }, settings)
    assert_equal 'my_key', result['key']
  end

  test 'normalize_note_type sets key to nil when blank' do
    settings = {}
    result = ExtraNotesHelper.normalize_note_type({ 'id' => 'x', 'key' => '   ' }, settings)
    assert_nil result['key']
  end

  test 'normalize_note_type sets key to nil when missing' do
    settings = {}
    result = ExtraNotesHelper.normalize_note_type({ 'id' => 'x' }, settings)
    assert_nil result['key']
  end
end
