
class QuestionsController < ApplicationController
  before_filter :find_question, :only => [:show, :edit, :update, :destroy]
  filter_resource_access

  # GET /questions
  # GET /questions.xml
  def index
    @assessment = Assessment.find(params[:assessment_id])

    respond_to do |wants|
      wants.html # index.html.erb
      wants.xml  { render :xml => @assessments }
    end
  end

  # GET /questions/1
  # GET /questions/1.xml
  def show
    @assessment = Assessment.find(params[:assessment_id])
    respond_to do |wants|
      wants.html # show.html.erb
      wants.xml  { render :xml => @question }
    end
  end

  # GET /questions/new
  # GET /questions/new.xml
  def new
    @question = Question.new
    @qt = QuestionType.all
    @assessment = Assessment.find(params[:assessment_id])

    respond_to do |wants|
      wants.html # new.html.erb
      wants.xml  { render :xml => @question }
    end
  end

  # GET /questions/1/edit
  def edit
    @assessment = Assessment.find(params[:assessment_id])
    @qt = QuestionType.all
    @question = Question.find(params[:id])
  end

  # POST /questions
  # POST /questions.xml
  def create
    @question = Question.new(params[:question])
    #TODO: Not sure why we have to manually set assessment_id - need to look into it
    #Suraj
    @assessment = Assessment.find(params[:assessment_id])
    @question.assessment_id = params[:assessment_id]

    respond_to do |wants|
      if @question.save
        flash[:success] = 'Question was successfully created.'
        wants.html { redirect_to assessment_path(@assessment) }
        wants.xml  { render :xml => @question,
                            :status => :created,
                            :location => @question }
      else
  flash[:error] = 'Failed to create question'
        wants.html { redirect_to :action=>"new" }#{ render :action => "new" }
        wants.xml  { render :xml => @question.errors,
                            :status => :unprocessable_entity }
      end
    end
  end

  # PUT /questions/1
  # PUT /questions/1.xml
  def update
    @assessment = Assessment.find(params[:assessment_id])

    respond_to do |wants|
      if @question.update_attributes(params[:question])
        flash[:success] = 'Question was successfully updated.'
        wants.html { redirect_to assessment_path(@assessment) }
        wants.xml  { head :ok }
      else
        wants.html { render :action => "edit" }
        wants.xml  { render :xml => @question.errors,
                            :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /questions/1
  # DELETE /questions/1.xml
  def destroy
    @assessment = Assessment.find(params[:assessment_id])
    @question.destroy

    respond_to do |wants|
      flash[:success] = 'The question was successfully deleted.'
      wants.html { redirect_to assessment_path(@assessment) }
      wants.xml  { head :ok }
    end
  end

  private
    def find_question
      @question = Question.find(params[:id])
    end

end
