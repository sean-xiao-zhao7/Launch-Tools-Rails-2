# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20100902210556) do

  create_table "analyses", :force => true do |t|
    t.integer  "assessment_id"
    t.boolean  "ShowIntro"
    t.text     "IntroText"
    t.boolean  "ShowBasicText"
    t.text     "BasicText"
    t.boolean  "ShowBasic_SelfText"
    t.text     "Basic_SelfText"
    t.boolean  "ShowBasic_FeedbackText"
    t.text     "Basic_FeedbackText"
    t.boolean  "ShowAdvancedText"
    t.text     "AdvancedText"
    t.boolean  "ShowAdvanced_SimilarText"
    t.text     "Advanced_SimilarText"
    t.boolean  "ShowAdvanced_EBSText"
    t.text     "Advanced_EBSText"
    t.boolean  "ShowAdvanced_PBSText"
    t.text     "Advanced_PBSText"
    t.boolean  "ShowGrowthPlanText"
    t.text     "GrowthPlanText"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "answers", :force => true do |t|
    t.integer  "assessment_take_id"
    t.integer  "question_id"
    t.integer  "value"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "text"
    t.boolean  "dont_know"
  end

  create_table "assessment_takes", :force => true do |t|
    t.integer  "user_id"
    t.integer  "assessment_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "parent_id"
    t.integer  "contact_id"
    t.boolean  "is_completed"
    t.string   "token"
  end

  create_table "assessment_tokens", :force => true do |t|
    t.integer  "assessment_id"
    t.integer  "user_id"
    t.string   "gift_email"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "giver_id"
    t.integer  "group_id"
    t.string   "status"
  end

  create_table "assessments", :force => true do |t|
    t.string   "title"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "completed"
    t.integer  "pagination"
  end

  create_table "at_instructions", :force => true do |t|
    t.integer  "assessment_id"
    t.text     "intro"
    t.text     "main"
    t.text     "pre_take"
    t.text     "fb_welcome"
    t.text     "fb_save"
    t.text     "fb_submit"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "balances", :force => true do |t|
    t.integer  "user_id"
    t.integer  "group_id"
    t.integer  "balance"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "categories", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.integer  "assessment_id"
    t.integer  "parent_id"
    t.integer  "prev_id"
    t.integer  "next_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "checkins", :force => true do |t|
    t.integer   "reminder_times_actual"
    t.integer   "reminder_times_target"
    t.date      "reminder_checkin_date"
    t.integer   "step_id"
    t.timestamp "created_at"
    t.timestamp "updated_at"
    t.date      "start_date"
    t.date      "until_date"
  end

  create_table "contacts", :force => true do |t|
    t.integer  "user_id"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "email"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "step_id"
  end

  create_table "delayed_jobs", :force => true do |t|
    t.integer  "priority",   :default => 0
    t.integer  "attempts",   :default => 0
    t.text     "handler"
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "delayed_jobs", ["priority", "run_at"], :name => "delayed_jobs_priority"

  create_table "goals", :force => true do |t|
    t.string   "description"
    t.string   "target"
    t.boolean  "completed"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
    t.string   "category"
    t.string   "reward_file_name"
    t.string   "reward_content_type"
    t.integer  "reward_file_size"
    t.datetime "reward_updated_at"
    t.integer  "position"
  end

  create_table "groups", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "picture_file_name"
    t.string   "picture_content_type"
    t.integer  "picture_file_sizes"
    t.datetime "picture_updated_at"
    t.boolean  "activated"
    t.integer  "tokens"
    t.string   "head_coach_title"
    t.string   "coach_title"
    t.string   "student_title"
    t.boolean  "block_feedback"
  end

  create_table "invitations", :force => true do |t|
    t.integer  "sender_id"
    t.integer  "group_id"
    t.string   "token"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "email"
    t.string   "status"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "role_id"
  end

  create_table "mc_options", :force => true do |t|
    t.text     "content"
    t.integer  "value"
    t.integer  "question_id"
    t.integer  "category_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "feedback_content"
  end

  create_table "memberships", :force => true do |t|
    t.integer  "group_id"
    t.integer  "user_id"
    t.integer  "role_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "coach_id"
    t.string   "coach_status"
  end

  create_table "question_types", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "questions", :force => true do |t|
    t.integer  "question_type_id"
    t.text     "content"
    t.integer  "assessment_id"
    t.integer  "category_id"
    t.integer  "parent_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "value"
    t.integer  "position"
    t.text     "feedback_content"
  end

  create_table "result_types", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "results", :force => true do |t|
    t.integer  "result_type_id"
    t.integer  "assessment_id"
    t.boolean  "is_feedback"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "roles", :force => true do |t|
    t.string "name"
  end

  create_table "steps", :force => true do |t|
    t.string   "description"
    t.integer  "goal_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "completed"
    t.string   "reminder_type"
    t.date     "reminder_checkin_date"
    t.integer  "contact_id"
    t.date     "start_date"
    t.date     "until_date"
    t.integer  "reminder_freq"
  end

  create_table "transactions", :force => true do |t|
    t.string   "transaction_type"
    t.integer  "user_id"
    t.integer  "group_id"
    t.string   "gift_email"
    t.integer  "tokens"
    t.integer  "cost"
    t.string   "token"
    t.string   "transaction_id"
    t.text     "params"
    t.string   "status"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "group_name"
    t.integer  "assessment_id"
  end

  create_table "users", :force => true do |t|
    t.string   "email",                                   :null => false
    t.string   "crypted_password",                        :null => false
    t.string   "password_salt",                           :null => false
    t.string   "persistence_token",                       :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "gender"
    t.date     "birth_date"
    t.string   "country"
    t.string   "province_or_state"
    t.string   "role"
    t.boolean  "verified",             :default => false
    t.string   "perishable_token"
    t.integer  "active_membership_id"
  end

end
