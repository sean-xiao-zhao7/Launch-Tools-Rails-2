class CreateAnalyses < ActiveRecord::Migration
  def self.up
    create_table :analyses do |t|
      t.integer :assessment_id
      t.boolean :ShowIntro
      t.text :IntroText
      t.boolean :ShowBasicText
      t.text :BasicText
      t.boolean :ShowBasic_SelfText
      t.text :Basic_SelfText
      t.boolean :ShowBasic_FeedbackText
      t.text :Basic_FeedbackText
      t.boolean :Show_AdvancedText
      t.text :AdvancedText
      t.boolean :ShowAdvanced_SimilarText
      t.text :Advanced_SimilarText
      t.boolean :ShowAdvanced_EBSText
      t.text :Advanced_EBSText
      t.boolean :ShowAdvanced_PBS
      t.text :Advanced_PBS
      t.boolean :ShowGrowthPlanText
      t.text :GrowthPlanText

      t.timestamps
    end
  end

  def self.down
    drop_table :analyses
  end
end
