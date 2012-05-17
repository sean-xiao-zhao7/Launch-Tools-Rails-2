class GroupsController < ApplicationController
  before_filter :find_group, :only => [:show, :edit, :manage, :purchase_tokens, :update, :destroy, :members_list]
  before_filter { |c| c.set_title "Groups" }

  # GET /groups
  # GET /groups.xml
  def index
  @groups = Group.all

    respond_to do |wants|
      wants.html # index.html.erb
      wants.xml { render :xml => @groups }
    end
  end

  # GET /groups/1
  # GET /groups/1.xml
  def show
    respond_to do |wants|
      wants.html # show.html.erb
      wants.xml { render :xml => @group }
    end
  end

  # GET /groups/new
  # GET /groups/new.xml
  def new
  @group = Group.new
  @group.head_coach_title = 'Head-Coach'
  @group.coach_title = 'Coach'
  @group.student_title = 'Student'

  respond_to do |wants|
    wants.html # new.html.erb
    wants.xml { render :xml => @group }
  end
  end

  # GET /groups/1/edit
  def edit
    # For AJAX "edit in place"
    # params[:field] holds what to edit
    if params[:field] == "reward"
      render 'edit_reward.js.erb'
    end    
  end

  # POST /groups
  # POST /groups.xml
  def create
    @group = Group.new(params[:group])
    @group.head_coach_title = 'Head-Coach' unless @group.head_coach_title
    @group.coach_title = 'Coach' unless @group.coach_title
    @group.student_title = 'Student' unless @group.student_title    
    
    respond_to do |wants|
      if @group.save
        # Set current owner
        @group.owner = current_user

        # Also make this group the active group for the user
        @group.owner.memberships.find_by_group_id(@group.id).activate

        flash[:notice] = 'Your group was successfully created.'
        wants.html { redirect_to manage_group_path(@group) }
        wants.xml { render :xml => @group, :status => :created, :location => @group }
      else
        wants.html { render :action => "new" }
        wants.xml { render :xml => @Group.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /groups/1
  # PUT /groups/1.xml
  def update
    respond_to do |wants|
      if @group.update_attributes(params[:group])
        flash[:notice] = 'The group was successfully updated.'
        wants.html { redirect_to(@group) }
        wants.xml { head :ok }
      else
        wants.html { render :action => "edit" }
        wants.xml { render :xml => @Group.errors, :status => :unprocessable_entity }
      end
    end
  end

  # Page to manage the group - send invitations, pair up coaches, buy tokens
  def manage
  end

  # http://www.2dconcept.com/jquery-grid-rails-plugin
  def members_list
    order = (params[:sidx] != "")? params[:sidx] : 'role_id'
    order += ' '
    order += (params[:sord] != "")? params[:sord] : 'asc'
    @memberships = @group.memberships.find(:all, :include => [:user, :role], :order => order ) do
      ##{(!params[:sidx].nil?)? params[:sidx] : 'role_id'} #{(!params[:sord].nil?)? params[:sord] : 'asc'}
      if params[:_search] == "true"
        user.last_name  =~ "%#{params[:'users.last_name']}%" if params[:'users.last_name'].present?
        user.first_name =~ "%#{params[:'users.first_name']}%" if params[:'users.first_name'].present?
        user.email      =~ "%#{params[:'users.email']}%" if params[:'users.email'].present?
        user.gender     =~ "%#{params[:'users.gender']}%" if params[:'users.gender'].present?
        group_role      =~ "%#{params[:'role_id']}%" if params[:'role_id'].present?
        user.birth_date =~ "%#{params[:'users.birth_date']}%" if params[:'users.birth_date'].present?
      end
      paginate :page => params[:page], :per_page => params[:rows]
      #order_by user.gender # => works!  *LOOK HERE*
      # order_by 'user.gender' => fails!   *LOOK HERE*
      #"#{params[:sidx]} #{params[:sord]}"
    end
    respond_to do |format|
      format.json { render :json => @memberships.to_jqgrid_json(['user.last_name', 'user.first_name', 'user.email', 'user.gender', 'group_role', 'user.birth_date'],
                                                       params[:page], params[:rows], @memberships.count) }
      #format.json { render :json => @members.to_jqgrid_json([:last_name, :first_name, :gender, :birth_date, :country, :email, :verified, :role],
      #                                                 params[:page], params[:rows], @users.total_entries) }
    end
  end

  # Page to purchase tokens
  def purchase_tokens
    @transaction = Transaction.new
    @transaction.group = @group
  end

  # DELETE /groups/1
  # DELETE /groups/1.xml
  def destroy
    @group.destroy

    respond_to do |wants|
      wants.html { redirect_to :back }
      wants.xml { head :ok }
    end
  end

  private

    def find_group
      @group = Group.find(params[:id])
    end

end