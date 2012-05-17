class ContactsController < ApplicationController

  before_filter :set_title

  before_filter :find_contact, :only => [:show, :edit, :update, :delete, :destroy, :accountability]

  filter_resource_access

  # GET /contacts
  # GET /contacts.xml
  def index
    if params[:term]
      @contacts = current_user.contacts.collect { |c| c if c.title =~ /#{params[:term].lstrip}/i }
      @contacts.compact!
    else
      @contacts = current_user.contacts.sort_by { |contact| contact.email }
    end

    respond_to do |wants|
      wants.html # index.html.erb
      wants.js
    end
  end

  # GET /contacts/1
  # GET /contacts/1.xml
  def show
    respond_to do |wants|
      wants.html # show.html.erb
      wants.xml { render :xml => @contact }
    end
  end

  # GET /contacts/new
  # GET /contacts/new.xml
  def new
    @contact = Contact.new

    respond_to do |wants|
      wants.html # new.html.erb
      wants.js
    end
  end

  # GET /contacts/1/edit
  def edit
    respond_to do |wants|
      wants.html # new.html.erb
      wants.js
    end
  end

  # POST /contacts
  # POST /contacts.xml
  def create
    @contact = Contact.new(params[:contact])
    @contact.user_id = current_user.id

    if params[:contact][:email] != current_user.email
      respond_to do |wants|
        if @contact.save
          flash[:success] = 'Contact was successfully created.'
          wants.html { redirect_to contacts_path }
          wants.js
        else
          wants.html { render :action => "new" }
          wants.js
        end
      end
    else
      flash[:error]= "You Cannot user your Email for a contact."
      render :action => "new"
    end
  end

  # PUT /contacts/1
  # PUT /contacts/1.xml
  def update
    respond_to do |wants|
      if @contact.update_attributes(params[:contact])
        flash[:success] = 'Contact was successfully updated.'
        wants.html { redirect_to contacts_path }
        wants.js
      else
        wants.html { render :action => "edit" }
        wants.js
      end
    end
  end

  def delete
    respond_to do |format|
      format.html
      format.js
    end
  end

  # DELETE /contacts/1
  # DELETE /contacts/1.xml
  def destroy
    Step.find_all_by_contact_id(@contact.id).each do |step|
      step.delete_contact
    end
    
    @contact.destroy
    
    respond_to do |wants|
      wants.html { redirect_to(contacts_url) }
      wants.js
    end
  end
  
  def accountability
    # Compare TOKENs here to
    # find the contact with the given id;
    # then, show all the steps that are entrusted to this person.
    @contact.steps.sort! { |a, b| a.reminder_checkin_date <=> b.reminder_checkin_date }
  end

  private

    def find_contact
      @contact = Contact.find(params[:id])
    end
  
    def set_title
      @title = "Contacts"
    end

end
