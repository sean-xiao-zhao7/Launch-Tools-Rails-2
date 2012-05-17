class InvitationsController < ApplicationController
  before_filter :find_group_or_user, :only => [:index]
  before_filter :find_group, :only => [:new, :edit, :create, :email, :csv_import]
	before_filter :find_invitation, :only => [:show, :edit, :update, :destroy, :accept, :reject]

  # For CSV Imports
  map_fields :csv_import, ['First name', 'Last name', 'Email', 'Role'], :file_field => :file, :params => [:csv]

	# GET /invitations
	# GET /invitations.xml
	def index
    @invitations = @group.invitations if @group
    #TODO: User Invitations
    @invitations ||= @user.invitations if @user

		respond_to do |wants|
			wants.html # index.html.erb
			wants.xml { render :xml => @invitations }
		end
	end

	# GET /invitations/1
	# GET /invitations/1.xml
	def show
      respond_to do |wants|
          wants.html # show.html.erb
          wants.xml { render :xml => @invitation }
      end
	end

	# GET /invitations/new
	# GET /invitations/new.xml
	def new
    @invitations = @group.invitations.find_all_by_status('Uninvited')
    @invitation = Invitation.new
    @invitation.role = Role.find_by_name('Student')

    respond_to do |wants|
      wants.html # new.html.erb
      wants.xml { render :xml => @invitation }
    end
	end

	# GET /invitations/1/edit
	def edit
	end

	# POST /invitations
	# POST /invitations.xml
	def create
		@invitation = Invitation.new(params[:invitation])
    @invitation.group = @group
    @invitation.sender = current_user
    @invitation.status = 'Uninvited'

		respond_to do |wants|
			if @invitation.save
				#flash[:notice] = 'The invitation was successfully sent.'
				wants.html { redirect_to group_invitations_path(@group) }
        wants.js { }
				wants.xml { render :xml => @invitation, :status => :created, :location => @invitation }
			else
				wants.html { render :action => "new" }
        wants.js { }
				wants.xml { render :xml => @invitation.errors, :status => :unprocessable_entity }
			end
		end
	end

	# PUT /invitations/1
	# PUT /invitations/1.xml
	def update
		respond_to do |wants|
			if @invitation.update_attributes(params[:invitation])
				flash[:notice] = 'The invitation was successfully updated.'
				wants.html { redirect_to new_group_invitation_path(@group) }
				wants.xml { head :ok }
			else
				wants.html { render :action => "edit" }
				wants.xml { render :xml => @invitation.errors, :status => :unprocessable_entity }
			end
		end
	end

	# DELETE /invitations/1
	# DELETE /invitations/1.xml
	def destroy
		@invitation.destroy

		respond_to do |wants|
      flash[:success] = 'The invitation was successfully revoked.'
			wants.html { redirect_to :back }
      wants.js
			wants.xml { head :ok }
		end
  end

  def delete

    respond_to do |format|
      format.html
      format.js
    end
  end

  def csv_import
    if fields_mapped?
      default_role = Role.find_by_name('Student')

      success = true

      mapped_fields.each do |row|

        invitation = Invitation.new
        invitation.group = @group
        invitation.sender = current_user
        invitation.status = 'Uninvited'
        invitation.first_name=row[0]
        invitation.last_name=row[1]
        invitation.email=row[2]

        role = Role.find_by_name(row[3])
        if role
          invitation.role = role
        else
          invitation.role = default_role
        end

        # TODO: error handling for improper saving.
        if !invitation.save
          success = false
        end

      end

      if success
        flash[:success]="The CSV File was successfully imported."
        redirect_to new_group_invitation_path(@group)
      else
        flash[:error] = "There was a problem importing the csv file - make sure that the data is valid and the three mandatory columns (First name, Last name, Email) are correctly set."
        redirect_to new_group_invitation_path(@group)
      end
    else
      # Render csv_import.html.haml
    end

#    rescue MapFields::InconsistentStateError
#      flash[:error] = 'There was a problem processing the file - Please try again'
#      redirect_to :action => :new
#    rescue MapFields::MissingFileContentsError
#      flash[:error] = 'Please upload a file'
#      redirect_to :action => :new
  end

  # Send the group invitations
  def email
    # TODO: Non-Group Related User Invitations to the LAUNCH Tools Site
    # Use the delayed job plugin to process this in the background.
    @group.delay.send_invitation_emails
    # TODO: Errors for already invited members

    flash[:success] = "The invitations are being sent. You can check this page to view their status."
    redirect_to group_invitations_path(@group)
  end

  # Accepting & Rejecting invites
  def accept
    membership = Membership.new
    membership.user = User.find_by_email(@invitation.email)
    membership.group = @invitation.group
    membership.role = @invitation.role

    @invitation.status = 'Accepted'

    if membership.save && @invitation.save
      flash[:success] = "You have successfully joined the #{@invitation.group.name} Group"
    else
      # Redirect to contact support page
      flash[:error] = "There was a problem accepting the group invitation. Please contact support."
    end

    redirect_to :back
  end

  def reject
    @invitation.status = 'Rejected'
    
    if @invitation.save
      flash[:succcess] = "The group invitation was successfully rejected."
    else
      flash[:error] = "There was a problem rejecting the group invitation. Please contact support."
    end

    redirect_to :back
  end

	private

		def find_invitation
			@invitation = Invitation.find(params[:id])
    end

    def find_group_or_user
      @group = Group.find(params[:group_id]) if params[:group_id]
      @user = Group.find(params[:user_id]) if params[:user_id]
    end

    def find_group
      @group = Group.find(params[:group_id])
    end

    def find_user
      @user = Group.find(params[:user_id])
    end

    def send_invitation
      # If the user is new

      # If the user exists

    end

end