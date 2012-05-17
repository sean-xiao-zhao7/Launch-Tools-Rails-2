
class GoalsController < ApplicationController

  before_filter :set_title

  before_filter :set_goal, :except => [:index, :new, :create, :re_order_goals, :switch_target]
  before_filter :set_target, :only => [ :new, :edit, :create, :index ]
  before_filter :set_categories, :only => [:edit, :update ]
  before_filter :set_contacts, :only => [ :index ]

  filter_resource_access
  filter_access_to :re_order_goals, :attribute_check => false
  filter_access_to :switch_target, :attribute_check => false 

  # GET /goals
  # GET /goals.xml

  def index
    @completed_goals = current_user.goals.find_all_by_completed(true, :order =>'position')
    @current_goals = current_user.goals.all - @completed_goals 
    @current_goals.sort! { |x, y| x.position <=> y.position }
    @user = current_user
  end
  
  def show
    respond_to do |format|
      format.html { redirect_to goals_path }
    end
  end

  def re_order_goals
    user = User.find(params[:id])
    goals1 = user.goals.find_all_by_completed(false, :order =>'position')
    goals2 = user.goals.find(:all, :conditions => {:completed => nil}, :order =>'position')
    goals = goals1 + goals2
    goals.each do |goal|
      goal.position = params['goal'].index(goal.id.to_s) + 1
      goal.save
    end
    @goals = current_user.goals.all(:order =>'position')
    respond_to do |wants|
      wants.js
    end
  end

  # GET /goals/new
  # GET /goals/new.xml
  def new
    @goal = Goal.new( :description => "My New Goal", 
                      :user_id => current_user.id,
                      :reward_content_type => "image/png",
                      :reward_file_size => 1) # the last two are set so the validation passes
    render "new.html"
    #@goal.save
    #respond_to do |format|
    #  flash[:success] = "New Goal Added!"
    #  format.html
    #  format.js
    #end
  end

  # GET /goals/1/edit
  def edit
    respond_to do |format|
      format.html
      format.js do
        if params[:field] == "description"
          render :partial => 'edit_description'
        elsif params[:field] == "target"
          render 'edit_target'
        elsif params[:field] == "category"
          set_categories
          render 'edit_category'
        elsif params[:field] == "create_goal_category"
          render 'create_goal_category'
        elsif params[:field] == "create_goal_target"
          render 'create_goal_target'
        elsif params[:field] == "reward"
          @default_images = [["/images/rewards/fries.jpg", "Fries"], ["/images/rewards/ice_cream.jpg", "Ice Cream"], ["/images/rewards/strawberries.jpg", "Strawberries"], ["/images/rewards/sweet_and_sour_chicken.jpg", "Chicken"]]
          render 'edit_reward'
        end
      end
    end
  end

  # POST /goals
  # POST /goals.xml
  def create
    
    @goal = Goal.new(params[:goal])    
    @goal.user_id = @current_user.id
    @goal.category ||= params[:category] unless params[:category].nil?
    # must have a content type if you are to validate the type of the file uploaded
    @goal.reward_content_type = "image/png"
    @goal.reward_file_size = 1

    respond_to do |format|
      begin @goal.save!
        flash[:success] = "New Goal Added!"
        format.html { redirect_to goals_path }
        format.js
      rescue ActiveRecord::RecordInvalid => invalid
        flash[:error] = invalid.message
        format.html { render 'new' }
        format.js { render 'error' }
      end
    end
  end

  # PUT /goals/1
  # PUT /goals/1.xml
  def update
    respond_to do |format|
      begin # catch exceptions
        @goal.update_attributes!(params[:goal])        
        format.html { redirect_to goals_path }
        format.js do
          if params[:goal][:description]
            flash[:success] = "Goal Description Successfully updated!"
            render 'update_description'
          elsif params[:goal][:target]
            set_categories
            flash[:success] = "Goal Target Area Successfully updated!"
            render 'update_target'
          elsif params[:goal][:category]
            flash[:success] = "Goal Attribute Successfully updated!"
            render 'update_category'
          elsif params[:goal][:completed]
            render 'update_complete'
          end
        end        
      rescue ActiveRecord::RecordInvalid => invalid        
        @error = invalid.message # use this to tell the user what went wrong
        format.html { redirect_to goals_path }        
        format.js        
      end
    end
  end

  # DELETE /goals/1
  # DELETE /goals/1.xml
  def destroy

    @goal.destroy

    respond_to do |format|
      format.html { redirect_to goals_path }
      format.js
    end
  end
  
  def delete
    
    respond_to do |format|
      format.html { render "delete" }
      format.js
    end
  end
  
  def switch_target
    @target = params[:target]
    unless @target == "Select a Target"
      @categories = set_categories_for_craetion(@target)
    end
    respond_to do |wants|
      wants.js
    end
  end

private

  def set_goal
    @goal = Goal.find(params[:id])
  end

  def set_title
    @title = "Growth Plan"
  end
  
  def set_target
    @targets = Array.new   
    @targets << "Select a Target"
    Assessment.all.each do |assessment|
      @targets << assessment.title
    end
  end
  
  def set_categories
    if params[:goal] && params[:goal][:target] && params[:goal][:target] != "Select a Target"
      @target = params[:goal][:target]
    elsif @goal.has_target? 
      @target = @goal.target      
    else
      return
    end
    @categories = Array.new   
    parent_categories = Assessment.find_by_title(@target).parent_categories
    @categories << "Select a #{parent_categories.collect { |c| c.name.singularize}.join('/')}"
    if @goal.categories
      @goal.categories.each do |cat|
        @categories << cat.name
      end    
    end
  end
  
  def set_categories_for_craetion(target)
    @categories = Array.new   
    parent_categories = Assessment.find_by_title(target).parent_categories
    @categories << "Select a #{parent_categories.collect { |c| c.name}.join('/')}"
    child_categories = Assessment.find_by_title(target).child_categories
    unless child_categories.nil?
      child_categories.each do |cat|
        @categories << cat.name  
      end
    end
    return @categories
  end
  
  
  def set_contacts
    @contacts = Array.new
    @contacts = current_user.contacts 
  end
  
end
