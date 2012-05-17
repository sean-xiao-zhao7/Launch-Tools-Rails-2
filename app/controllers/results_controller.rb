class ResultsController < ApplicationController
  before_filter :find_result, :only => [:show, :edit, :update, :destroy]
  before_filter :find_assessment
  filter_resource_access

  # GET /results
  # GET /results.xml
  def index
  @results = Result.all

    respond_to do |wants|
      wants.html # index.html.erb
      wants.xml { render :xml => @results }
    end
  end

  # GET /results/1
  # GET /results/1.xml
  def show
    respond_to do |wants|
      wants.html # show.html.erb
      wants.xml { render :xml => @result }
    end
  end

  # GET /results/new
  # GET /results/new.xml
  def new
  @result = Result.new

    respond_to do |wants|
      wants.html # new.html.erb
      wants.xml { render :xml => @result }
    end
  end

  # GET /results/1/edit
  def edit
  end

  # POST /results
  # POST /results.xml
  def create
    @result = Result.new(params[:result])
    @result.assessment_id = @assessment.id

    respond_to do |wants|
      if @result.save
        flash[:success] = 'The result was successfully created.'
        wants.html { redirect_to(@assessment) }
        wants.xml { render :xml => @result, :status => :created, :location => @result }
      else
        wants.html { render :action => "new" }
        wants.xml { render :xml => @result.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /results/1
  # PUT /results/1.xml
  def update
    respond_to do |wants|
      if @result.update_attributes(params[:result])
        flash[:success] = 'Result was successfully updated.'
        wants.html { redirect_to(@result) }
        wants.xml { head :ok }
      else
        wants.html { render :action => "edit" }
        wants.xml { render :xml => @result.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /results/1
  # DELETE /results/1.xml
  def destroy
    @result.destroy

    respond_to do |wants|
      wants.html { redirect_to(results_url) }
      wants.xml { head :ok }
    end
  end

  private

    def find_result
      @result = Result.find(params[:id])
      @assessment = Assessment.find(params[:assessment_id])
    end

    def find_assessment
      @assessment = Assessment.find(params[:assessment_id])
    end

end