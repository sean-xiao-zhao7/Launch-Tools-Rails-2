class RemoveGroupTokens < ActiveRecord::Migration
# Undo create group tokens

# For requiring migrations we need the full path to the file.
require Rails.root.join('db', 'migrate', '20100811161437_create_group_tokens')

  def self.up
    CreateGroupTokens.down
  end

  def self.down
    CreateGroupTokens.up
  end
end
