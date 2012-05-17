class CategoriesController < ApplicationController
  before_filter :find_category, :only => [:show, :edit, :update, :destroy]
  #TODO: where is find_category used? Adding it makes things work.


  filter_resource_access

  def index
    @assessment = Assessment.find(params[:assessment_id])

    respond_to do |wants|
      wants.html # index.html.erb
      wants.xml  { render :xml => @assessments }
    end
  end

  def show
    @assessment = Assessment.find(params[:assessment_id])

    respond_to do |wants|
      wants.html # show.html.erb
      wants.xml  { render :xml => @category }
    end
  end

  def new
    @category = Category.new
    @assessment = Assessment.find(params[:assessment_id])
    @parents = @assessment.parent_categories
    respond_to do |wants|
      wants.html # new.html.erb
      wants.xml  { render :xml => @category }
    end
  end

  def edit
    @assessment = Assessment.find(params[:assessment_id])
  end

  def create
    @category = Category.new(params[:category])
    #TODO: Not sure why we have to manually set assessment_id - need to look into it
    #Suraj
    @assessment = Assessment.find(params[:assessment_id])
    @category.assessment_id = params[:assessment_id]

    respond_to do |wants|
      if @category.save
        flash[:success] = 'The Category was successfully created.'
        wants.html { redirect_to assessment_path(@assessment) }
        wants.xml  { render :xml => @category,
                            :status => :created,
                            :location => @category }
      else
        wants.html { render :action => "new" }
        wants.xml  { render :xml => @category.errors,
                            :status => :unprocessable_entity }
      end
    end
  end

  def update
    @assessment = Assessment.find(params[:assessment_id])

    respond_to do |wants|
      if @category.update_attributes(params[:category])
        flash[:success] = 'The category was successfully updated.'
        wants.html { redirect_to assessment_path(@assessment) }
        wants.xml  { head :ok }
      else
        wants.html { render :action => "edit" }
        wants.xml  { render :xml => @category.errors,
                            :status => :unprocessable_entity }
      end
    end
  end

  def destroy
    @assessment = Assessment.find(params[:assessment_id])
    @category.destroy

    respond_to do |wants|
      flash[:success] = 'The category was successfully deleted.'
      wants.html { redirect_to assessment_path(@assessment) }
      wants.xml  { head :ok }
    end
  end

  private

    def find_category
      @category = Category.find(params[:id])
    end

end
