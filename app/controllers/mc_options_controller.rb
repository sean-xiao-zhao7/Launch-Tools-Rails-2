class McOptionsController < ApplicationController

  #filter_resource_access

  def index
    @q = Question.find(:first,:conditions=>["id = ?",params[:question_id]])
    @a = Assessment.find(:first,:conditions=>["id = ?",params[:assessment_id]])
  end

  def new
    @option = McOption.new
    @q = Question.find(:first,:conditions=>["id = ?",params[:question_id]])
    @a = Assessment.find(:first,:conditions=>["id = ?",params[:assessment_id]])
    respond_to do |r|
      r.html
    end
  end

  def destroy
    McOption.find(params[:id]).destroy
     redirect_to :back#assessment_question_mc_option_path()
  end

  def create
    @option = McOption.new(params["mc_option"])
    @option.question_id = params[:question_id]
    if @option.save
      flash[:notice]="Option added"
      redirect_to assessment_question_mc_options_url(params[:assessment_id],params[:question_id])
    else
      flash[:notice]="Option Failed"
      redirect_to :back
    end
  end

  def edit
    @o = McOption.find(params[:id])
    @q = Question.find(:first,:conditions=>["id = ?",params[:question_id]])
    @a = Assessment.find(:first,:conditions=>["id = ?",params[:assessment_id]])
  end

  def update
    #assessment = Assessment.find(params[:assessment_id])
    q = McOption.find(params[:id])
    if q.update_attributes!(params[:mc_option])
      redirect_to assessment_question_mc_options_path(params[:assessment_id],params[:question_id])
    else
      flash[:notice] = "An error has occured"
      redirect_to :back
    end
  end

end
