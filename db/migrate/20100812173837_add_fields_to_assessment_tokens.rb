class AddFieldsToAssessmentTokens < ActiveRecord::Migration
  def self.up
    add_column :assessment_tokens, :giver_id, :integer
    add_column :assessment_tokens, :group_id, :integer
    add_column :assessment_tokens, :status, :string
  end

  def self.down
    remove_column :assessment_tokens, :status
    remove_column :assessment_tokens, :group_id
    remove_column :assessment_tokens, :giver_id
  end
end
