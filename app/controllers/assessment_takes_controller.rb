class AssessmentTakesController < ApplicationController
  # Authentication
  before_filter :find_assessment_take, :only => [:show, :update, :destroy, :results, :summary, :fb_resend_email, :fb_welcome, :fb_take, :fb_save, :fb_submit]
  before_filter :set_title

  filter_resource_access
  filter_access_to :options, :attribute_check => false
  filter_access_to :index, :attribute_check => false

  def index #show all takes....
    @assessment_takes = AssessmentTake.find(:all,:conditions => ["user_id = ?",current_user.id])
    # TODO: Needs to be released assessments only
    @assessments = Assessment.find(:all,:conditions => ["completed = ?",true])
  end

  # Lists the assessment options
  def options
    # TODO: Needs to be released assessments only
    @assessments = Assessment.all
  end

  # The main instruction page before an assessment take is created
  def new
    @assessment = Assessment.find(params[:assessment_id])
    
    respond_to do |format|
      format.html
      format.js
    end
  end

  def create #
    @assessment = Assessment.find(params[:assessment_id])
    @assessment_take = @assessment.make_assessment_take(current_user)
    success = (@assessment_take == -1)? false : true

    respond_to do |wants|
      # TODO: Need to add in code for failed assessment take creations.
      if success
        # Redirect to dashboard.
        wants.html {redirect_to :root}
        # Redirect to summary page.
        #wants.html { redirect_to :controller => "assessment_takes",:action => "summary", :id => @assessment_take }
        #wants.js
      else
        wants.html { redirect_to :back}
      end
    end
  end

  def show #
      @assessment_take = AssessmentTake.find(params[:id])
  end

  def delete
    @assessment_take = AssessmentTake.find(params[:id])
    @assessment = Assessment.find(params[:assessment_id])
    respond_to do |format|
      format.html
      format.js
    end
  end

  def destroy #option1...  t
    redirect_to root_path and return if params[:cancel]
    @assessment_take = AssessmentTake.find(params[:id])
    @assessment_take.destroy
    respond_to do |wants|
        wants.html { redirect_to root_path }
        wants.js
    end
  end

  def edit
    
    params[:page] = params[:assessment_take][:page].to_i if params[:assessment_take]
    params[:assessment_take].delete(:page) if params[:assessment_take]
    assessment_take = AssessmentTake.find(params[:id])
    @per_page=assessment_take.assessment.pagination
    page_save(params[:page],@per_page) if !params[:page].nil?
    params[:page] ||= 1
    if params[:commit]
      
      if params[:commit] == "<<"
        params[:page] -= 1
      elsif params[:commit] == ">>"
        params[:page] += 1
      elsif params[:commit] == "Save and Exit"
        #pass
      else
        params[:page] = params[:commit].to_i
      end
      
    end
    @assessment_take = AssessmentTake.find(params[:id])
    if params[:page].nil?
      params[:page]=1
    end
    @questions = @assessment_take.assessment.questions.all.paginate( :page => params[:page], :per_page => @per_page)
    @page = params[:page].to_i
    if params[:commit] == "Save and Exit"
      if !@assessment_take.contact.nil? # If it's a feedback user
        redirect_to fbtake_save_path(:token => @assessment_take.token)
      else
        # Redirect to Dashboard
        redirect_to root_path
        # Summary Page
        #redirect_to atake_path(:action => "summary", :assessment_id => @assessment_take.assessment, :id => @assessment_take)
      end
    end
  end
  
  def page_save(page,per_page)
    @assessment_take = AssessmentTake.find(params[:id])
    @assessment_take.update_attributes(params[:assessment_take])
    @assessment_take.save!
    if params[:cb]
      per_page.times do |i|
        if (page-1)*per_page+i< @assessment_take.assessment.questions.length
          if @assessment_take.assessment.questions.all[(page-1)*per_page+i].question_type.name == "Choose-many"
            ans = @assessment_take.answers.find(:all,:conditions=>{:question_id=>@assessment_take.assessment.questions.all[((page-1)*per_page+i)]})[0]
            ans.value = 0
            if params[:cb]
              params[:cb].each do |a|
                a.keys.each do |k|
                  ans = Answer.find(k.to_i)
                  ans.value = 0
                  a[k].each do |opt|
                    ans.set(opt.to_i)
                  end
                  ans.save!
                end
              end
            end
          end
        end
      end
    else
    end
  end

  def update
    @assessment_take = AssessmentTake.find(params[:id])
    @assessment_take.update_attributes(params[:assessment_take])
    @assessment_take.answers.each do |a|
      if a.question.question_type.name == "Choose-many"
        a.value = 0
      end
    end
    if params[:cb]
      params[:cb].each do |a|
        a.keys.each do |k|
          ans = Answer.find(k.to_i)
          ans.value = 0
          a[k].each do |opt|
            ans.set(opt.to_i)
          end
          ans.save!
        end
      end
    else
    end
    if !@assessment_take.contact.nil? # If it's a feedback user
      redirect_to fbtake_save_path(:token => @assessment_take.token)
    else
      redirect_to atake_path(:action => "summary", :assessment_id => @assessment_take.assessment, :id => @assessment_take)
    end
  end


  # Assessment Take Summary Page
  def summary
      @assessment_take = AssessmentTake.find(params[:id])
      @fbtakes = @assessment_take.feedback_takes
  end

  # Adding Feedback Users

  def new_feedback_member
    @contact = Contact.new
    existing_fb_emails = @assessment_take.get_feedback_emails
    @possible_fb_members = []
    current_user.contacts.each do |contact|
      @possible_fb_members << contact unless existing_fb_emails.include?(contact.email)
    end
    # @possible_fb_members = current_user.contacts.collect { |contact| contact unless existing_fb_emails.include?(contact.email)}
    #debugger
    respond_to do |format|
      format.html
      format.js
    end
  end

  def add_feedback_member
    # Find the contact if the contact exists.
    @contact = Contact.find(params[:contact]["id"]) if !params[:contact]["id"].nil?
    @contact ||= Contact.find_by_email_and_user_id(params[:contact]["email"], current_user.id)

    # Create a feedback assessment for this contact
    @contact ||= Contact.new
    @contact.user_id = current_user.id
    @at = AssessmentTake.find(params[:id])
    @user = current_user
    success = false

    if params[:contact][:email] == current_user.email
      flash[:error] = "You cannot add yourself as a feedback member"
      success = false
    elsif (@at.get_feedback_emails).include?(params[:contact][:email])
      flash[:error] = "A feedback member with this e-mail address has already been added."
      success = false
    elsif @contact.update_attributes(params[:contact])
      @feedback_take = @at.assessment.make_assessment_take(current_user, @at, @contact)
      success = true if ( @feedback_take != -1)
      #send_feedback_email(@contact, @feedback_take, @user) if success
    else
      success = false
    end
    
    respond_to do |wants|
      if success
        # Redirect to dashboard
        wants.html { redirect_to root_path }
        # Redirect to summary page
        #wants.html { redirect_to :controller => "assessment_takes",:action => "summary", :id => @assessment_take }
        wants.js
      else
        wants.html { render :action => :new_feedback_member }
        # TODO:
        #wants.html { redirect_to atake_path(:action => "new_feedback_member", :assessment_id => @assessment_take.assessment.id ,:id => @assessment_take.id) }
        wants.js { render "error" }
      end
    end
  end

  # Feedback Users
  # @assessment_take is pre-initialized
  def send_feedback_email(contact, feedback_take, user)
     UserMailer.deliver_feedback_email(contact, feedback_take, user)
  end

  def fb_resend_email
    send_feedback_email(@assessment_take.contact, @assessment_take, @assessment_take.user)
    redirect_to :back
  end

  def fb_welcome
  end

  def fb_take
    redirect_to edit_assessment_assessment_take_path(@assessment_take.assessment.id,@assessment_take.id)
  end

  def fb_save
  end

  def fb_submit
  end

  ####################RESULTS
  def results
    @id = params[:id]
    @tb_p = build_table(params[:id],true)
    @tb_fb = build_table(params[:id],false)
    debugger
  end
  ###########################

  private

  def set_title
  @title = "New Assessment"
  end

  def find_assessment_take
    if (params[:id].nil?)
      @assessment_take = AssessmentTake.find_by_token(params[:token])
      # TODO: Redirect to an error page if the token doesn't exist.
      params[:id] = @assessment_take.id
      params[:assessment_id] = @assessment_take.assessment.id
    else
      @assessment_take = AssessmentTake.find(params[:id])
    end
  end

  def feedback_init
    @assessment_take = AssessmentTake.find_by_token(params[:token])
    params[:id] = @assessment_take.id # For Authlogic
  end

end
