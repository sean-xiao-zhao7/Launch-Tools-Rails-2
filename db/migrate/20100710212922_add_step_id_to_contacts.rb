class AddStepIdToContacts < ActiveRecord::Migration
  def self.up
    change_table :contacts do |contact|
      contact.integer :step_id
    end
  end

  def self.down
    change_table :contacts do |contact|
      contact.remove :step_id
    end
  end
end
