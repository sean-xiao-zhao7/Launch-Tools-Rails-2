class AssessmentsController < ApplicationController
  before_filter :find_assessment, :only => [:show, :edit, :update, :destroy]
  #before_filter :set_title
  before_filter { |c| c.set_title "Manage Assessments" }

  filter_resource_access

  # GET /assessments
  # GET /assessments.xml
  def index
    @assessments = Assessment.all

    respond_to do |wants|
      wants.html # index.html.erb
      wants.xml  { render :xml => @assessments }
    end
  end

  # GET /assessments/1
  # GET /assessments/1.xml
  def show
    @questions = @assessment.questions.all(:order =>'position')
    @categories = @assessment.categories
    @results = @assessment.results
    
    respond_to do |wants|
      wants.html # show.html.erb
      wants.xml  { render :xml => @assessment }
    end
  end

  def re_order_questions
    assessment = Assessment.find(params[:id])
    questions = assessment.questions
    questions.each do |task|
      task.position = params['questions'].index(task.id.to_s) + 1
      task.save
    end
    @questions = assessment.questions.all(:order =>'position')
    respond_to do |wants|
      wants.js
    end
  end

  # GET /assessments/new
  # GET /assessments/new.xml
  def new
    @assessment = Assessment.new
    respond_to do |wants|
      wants.html # new.html.erb
      wants.xml  { render :xml => @assessment }
    end
  end

  # GET /assessments/1/edit
  def edit
    flash[:notice]= @assessment.completed
  end

  # POST /assessments
  # POST /assessments.xml
  def create
    @assessment = Assessment.new(params[:assessment])
    respond_to do |wants|
      if @assessment.save
        flash[:success] = 'Assessment was successfully created.'
        wants.html { redirect_to(@assessment) }
        wants.xml  { render :xml => @assessment, :status => :created, :location => @assessment }
      else
        wants.html { render :action => "new" }
        wants.xml  { render :xml => @assessment.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /assessments/1
  # PUT /assessments/1.xml
  def update
    respond_to do |wants|
      if @assessment.update_attributes(params[:assessment])
        flash[:success] = 'Assessment was successfully updated.'
        wants.html { redirect_to(@assessment) }
        wants.xml  { head :ok }
       #flash[:notice]=@assessment.title
      else
        wants.html { render :action => "edit" }
        wants.xml  { render :xml => @assessment.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /assessments/1
  # DELETE /assessments/1.xml
  def destroy
    @assessment.destroy

    flash[:success] = 'Assessment was successfully deleted.'

    respond_to do |wants|
      wants.html { redirect_to(assessments_url) }
      wants.xml  { head :ok }
    end
  end

  private

    def find_assessment
      @assessment = Assessment.find(params[:id])
    end

end
