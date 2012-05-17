authorization do
  role :Admin do
    has_permission_on :admin_edit_user, :to => [:index, :edit, :destroy]
    has_permission_on :answers, :to => [:show]
    has_permission_on :assessment_takes, :to => [:index, :show, :options, :new, :edit, :create, :update, :delete, :destroy, :results, :summary, :add_feedback_member, :new_feedback_member, :options, :fb_welcome, :fb_take, :fb_save, :fb_submit, :fb_resend_email]
    has_permission_on :assessments, :to => [:index, :edit, :new, :create, :update, :destroy, :show, :re_order_questions]
    has_permission_on :categories, :to => [:index, :show, :new, :edit, :create, :update, :destroy ]
    has_permission_on :checkins, :to => [:index, :new, :create, :destroy, :delete]    
    has_permission_on :contacts, :to => [:accountability, :index, :create, :new, :show, :edit, :update, :delete, :destroy]
    has_permission_on :goals, :to => [:switch_target, :index, :show, :new, :edit, :create, :update, :destroy, :complete, :delete, :re_order_goals]    
    has_permission_on :mc_option, :to => [:index, :new, :create, :delete, :edit]
    has_permission_on :pages, :to => [:index, :home]
    has_permission_on :password_resets, :to => [:new, :create, :edit, :update]
    has_permission_on :question_types, :to => [:index, :new, :edit, :create, :update, :destroy]
    has_permission_on :questions, :to => [:index, :show, :new, :edit, :rate_edit, :many_edit, :one_edit, :text_edit, :create, :update, :destroy]
    has_permission_on :result_types, :to => [:index, :show, :new, :edit, :create, :update, :destroy]
    has_permission_on :results, :to => [:index, :show,:new, :edit, :create, :update, :destroy]
    has_permission_on :steps, :to => [:add_accountability, :create_accountability, :index, :show, :new, :edit, :create, :update, :destroy, :delete, :review_progress]    
    has_permission_on :user_sessions, :to => [:new, :create, :destroy]
    has_permission_on :user_verification, :to => [:show]
    has_permission_on :users, :to => [:new, :create, :show, :edit, :update, :password, :password_check, :index, :destroy, :new, :create,:user_email, :send_user_email, :check_password, :get_contacts_names, :get_contacts_emails]    
  end


  role :User do
    has_permission_on :answers, :to => [:show]
    has_permission_on :assessment_takes, :to => [:index, :show, :new, :edit, :create, :update, :delete, :destroy, :results, :summary, :add_feedback_member, :new_feedback_member, :options, :fb_welcome, :fb_take, :fb_save, :fb_submit]
    has_permission_on :assessments, :to => [:edit, :new, :create, :update, :destroy, :show]
    has_permission_on :categories, :to => [:index, :show, :new, :edit, :create, :update, :destroy ]
    has_permission_on :checkins, :to => [:index, :new, :create, :destroy, :delete]    
    has_permission_on :contacts, :to => [:accountability, :index, :new, :show, :edit, :create, :update, :delete, :destroy]
    has_permission_on :goals, :to => [:switch_target, :index, :show, :new, :edit, :create, :update, :destroy, :complete, :delete,:re_order_goals]
    has_permission_on :mc_option, :to => [:index, :new, :create]
    has_permission_on :pages, :to => [:index, :home]
    has_permission_on :password_resets, :to => [:new, :create, :edit, :update]
    has_permission_on :question_types, :to => [:index, :new, :edit, :create, :update, :destroy]
    has_permission_on :questions, :to => [:index, :show, :new, :edit, :rate_edit, :many_edit, :one_edit, :text_edit, :create, :update, :destroy]
    has_permission_on :result_types, :to => [:index, :show, :new, :edit, :create, :update, :destroy]
    has_permission_on :results, :to => [:index, :show,:new, :edit, :create, :update, :destroy]
    has_permission_on :steps, :to => [:add_accountability, :create_accountability, :index, :show, :new, :create, :delete, :destroy, :edit, :update, :review_progress]
    has_permission_on :user_sessions, :to => [:new, :create, :destroy]
    has_permission_on :user_verification, :to => [:show]
    has_permission_on :users, :to => [:show, :edit, :update, :password, :password_check, :check_password, :get_contacts_names, :get_contacts_emails]
  end


  role :guest do
    has_permission_on :assessment_takes, :to => [:edit, :options, :fb_welcome, :fb_take, :fb_save, :fb_submit]
    has_permission_on :contacts, :to => [:accountability]
    has_permission_on :pages, :to => [:index, :home]
    has_permission_on :password_resets, :to => [:new, :create, :edit, :update]
    has_permission_on :user_sessions, :to => [:new, :create]
    has_permission_on :user_verification, :to => [:show]
    has_permission_on :users, :to => [:new, :create]
  end

end
