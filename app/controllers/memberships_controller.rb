class MembershipsController < ApplicationController
  before_filter :find_group, :only => [:index, :show, :new, :create, :edit, :update, :destroy]
  before_filter :find_membership, :only => [:show, :edit, :update, :destroy, :activate, :deactivate]
  #TODO: Would be good to change controller title
  before_filter { |c| c.set_title "Groups" }

  # GET /memberships
  # GET /memberships.xml
  def index
  @memberships = @group.memberships

    respond_to do |wants|
      wants.html # index.html.erb
      wants.xml { render :xml => @memberships }
    end
  end

  # GET /memberships/1
  # GET /memberships/1.xml
  def show
    respond_to do |wants|
      wants.html # show.html.erb
      wants.xml { render :xml => @membership }
    end
  end

  # GET /memberships/new
  # GET /memberships/new.xml
  def new
  @membership = Membership.new
  @membership.group = @group

    respond_to do |wants|
      wants.html # new.html.erb
      wants.xml { render :xml => @membership }
    end
  end

  # GET /memberships/1/edit
  def edit
  end

  # POST /memberships
  # POST /memberships.xml
  def create
    @membership = Membership.new(params[:membership])
    @membership.group = @group

    respond_to do |wants|
      if @membership.save
        flash[:notice] = 'membership was successfully created.'
        wants.html { redirect_to group_memberships_path(@group) }
        wants.xml { render :xml => @membership, :status => :created, :location => @membership }
      else
        wants.html { render :action => "new" }
        wants.xml { render :xml => @membership.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /memberships/1
  # PUT /memberships/1.xml
  def update
    respond_to do |wants|
      if @membership.update_attributes(params[:membership])
        flash[:notice] = 'membership was successfully updated.'
        wants.html { redirect_to group_memberships_path(@group) }
        wants.xml { head :ok }
      else
        wants.html { render :action => "edit" }
        wants.xml { render :xml => @membership.errors, :status => :unprocessable_entity }
      end
    end
  end

  # Assign a coach
  def assign_coach
    @student_membership = Membership.find(params[:student_membership_id])
    @student_membership.coach_id = params[:coach_id]
    @student_membership.coach_status = 'Awaiting Acceptance'
    @student_membership.save
    respond_to do |wants|
      wants.js
    end
  end

  # DELETE /memberships/1
  # DELETE /memberships/1.xml
  def destroy
    @membership.destroy

    respond_to do |wants|
      wants.html { redirect_to :back }
      wants.xml { head :ok }
    end
  end

  # Makes this membership the active membership for the respective user
  def activate
    @membership.activate
    redirect_to :back
  end

  # Reset the user's active_membership to nil
  def deactivate
    @membership.deactivate
    redirect_to :back
  end

  private

    def find_membership
      @membership = Membership.find(params[:id])
    end

    def find_group
      @group = Group.find(params[:group_id])
    end

end