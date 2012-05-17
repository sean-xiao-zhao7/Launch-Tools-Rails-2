ActionController::Routing::Routes.draw do |map|
  map.resources :question_types #resources for question types.  Do not nest
  map.resources :result_types #do not nest

  #assessment routing table
  map.resources :assessments, :collection => { :re_order_questions => :post } do |assessments|
    assessments.resources :assessment_takes, :member => {:edit => :get, :edit => :put, :delete => :get} do |assessment_takes|
      assessment_takes.resource :analysis
    end
    assessments.resources :questions, :has_many => :mc_options
    assessments.resources :categories
    assessments.resources :results
  end

  map.atake 'assessments/:assessment_id/atake/:action/:id', :controller => 'assessment_takes'
  map.atake_options 'assessment_takes/options', :controller => 'assessment_takes', :action => 'options'

  #Feedback User routes
  map.fbtake_welcome 'assessments/feedback/welcome/:token', :controller => 'assessment_takes', :action => 'fb_welcome'
  map.fbtake 'assessments/feedback/:token', :controller => 'assessment_takes', :action => 'fb_take'
  #map.fbtake_edit 'assessments/feedback/take/:token', :controller => 'assessment_takes', :action => 'edit'
  map.fbtake_save 'assessments/feedback/save/:token', :controller => 'assessment_takes', :action => 'fb_save'
  map.fbtake_submit 'assessments/feedback/submit/:token', :controller => 'assessment_takes', :action => 'fb_submit'

  map.edit_at_instructions 'assessments/instructions/:id', :controller => 'at_instructions', :action => 'edit'

  map.root :controller => "pages", :action => "index"

  map.resources :pages, :collection => { :home => :get }

  # Users
  map.resource :account, :controller => "users"
  map.resources :users, :member => {:get_contacts_names => :get, :get_contacts_emails => :get} do |users|
    users.resources :invitations
  end
  map.show '/users/show/:id',:controller => "users", :action => "show"
  map.user_email '/users/user_email/:id',:controller => "users", :action => "user_email"
  map.check_password '/users/check_password/:id',:controller => "users", :action => "check_password"
  map.resource :user_session

  map.root :controller => "user_sessions", :action => "new"

  map.resources :goals, :collection => { :switch_target => :get, :re_order_goals => :put }, :member => { :delete => :get } do |goals|
    goals.resources :steps, :member => { :delete => :get, :add_accountability => :get, :create_accountability => :put, :review_progress => :get  } do |steps|
      steps.resources :checkins, :member => { :delete => :get}
    end
  end

  map.resources :contacts, :member => { :delete => :get, :accountability => :get }
  map.resources :user_verification
  map.resources :password_resets, :only => [ :new, :create, :edit, :update ]


  #assessments/1/questions/4/rate_edit
  map.q_edit 'assessments/:id/questions/:q/:action', :controller => "questions"

  map.mc_new 'assessments/:a/questions/:q/mc_option/new/',:controller => "mc_option", :action => "new"
  map.mc_create 'assessments/:a/questions/:q/mc_option/create/',:controller => "mc_option"
  map.mc_options 'assessments/:a/questions/:q/mc_option/index',:controller => "mc_option"
  #map.mc_edit 'assessments/:a/questions/:q/mc_option/:action/:mc',:controller => "mc_option"

  # Groups
  map.resources :groups, :member => { :manage => :get, :purchase_tokens => :get, :members_list => :get, :students_list => :get } do |groups|
    groups.resources :memberships, :member => { :activate => :get, :deactivate => :get, :assign_coach => :post }
    groups.resources :invitations, :member => { :delete => :get, :accept => :get, :reject => :get }, :collection => { :email => :get, :csv_import => :post }
  end

  # Invitations
  map.invite_new_user 'users/new/:invitation_token', :controller => 'users', :action => 'new'


  # Transactions
  # TODO: restrict to user?
  map.resources :transactions, :member => { :confirm => :get }, :collection => { :purchase_assessment => :post, :purchase_tokens => :post }
  # Paypal IPN URL
  map.paypal_notification 'paypal_notification', :controller => "transactions", :action => "paypal_notification"
  map.paypal_return 'paypal_return', :controller => "transactions", :action => "paypal_return"

  # The priority is based upon order of creation: first created -> highest priority.

  # Sample of regular route:
  #   map.connect 'products/:id', :controller => 'catalog', :action => 'view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   map.purchase 'products/:id/purchase', :controller => 'catalog', :action => 'purchase'
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   map.resources :products

  # Sample resource route with options:
  #   map.resources :products, :member => { :short => :get, :toggle => :post }, :collection => { :sold => :get }

  # Sample resource route with sub-resources:
  #   map.resources :products, :has_many => [ :comments, :sales ], :has_one => :seller

  # Sample resource route with more complex sub-resources
  #   map.resources :products do |products|
  #     products.resources :comments
  #     products.resources :sales, :collection => { :recent => :get }
  #   end

  # Sample resource route within a namespace:
  #   map.namespace :admin do |admin|
  #     # Directs /admin/products/* to Admin::ProductsController (app/controllers/admin/products_controller.rb)
  #     admin.resources :products
  #   end

  # You can have the root of your site routed with map.root -- just remember to delete public/index.html.
  # map.root :controller => "welcome"

  # See how all your routes lay out with "rake routes"

  # Install the default routes as the lowest priority.
  # Note: These default routes make all actions in every controller accessible via GET requests. You should
  # consider removing or commenting them out if you're using named routes and resources.
  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'


end


