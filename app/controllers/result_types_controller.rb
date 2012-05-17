class ResultTypesController < ApplicationController
  before_filter :find_result_type, :only => [:show, :edit, :update, :destroy]
  filter_resource_access

  # GET /result_types
  # GET /result_types.xml
  def index
  @result_types = ResultType.all

    respond_to do |wants|
      wants.html # index.html.erb
      wants.xml { render :xml => @result_types }
    end
  end

  # GET /result_types/1
  # GET /result_types/1.xml
  def show
    respond_to do |wants|
      wants.html # show.html.erb
      wants.xml { render :xml => @result_type }
    end
  end

  # GET /result_types/new
  # GET /result_types/new.xml
  def new
  @result_type = ResultType.new

    respond_to do |wants|
      wants.html # new.html.erb
      wants.xml { render :xml => @result_type }
    end
  end

  # GET /result_types/1/edit
  def edit
  end

  # POST /result_types
  # POST /result_types.xml
  def create
    @result_type = ResultType.new(params[:result_type])

    respond_to do |wants|
      if @result_type.save
        flash[:success] = 'result_type was successfully created.'
        wants.html { redirect_to(@result_type) }
        wants.xml { render :xml => @result_type, :status => :created, :location => @result_type }
      else
        wants.html { render :action => "new" }
        wants.xml { render :xml => @result_type.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /result_types/1
  # PUT /result_types/1.xml
  def update
    respond_to do |wants|
      if @result_type.update_attributes(params[:result_type])
        flash[:success] = 'result_type was successfully updated.'
        wants.html { redirect_to(@result_type) }
        wants.xml { head :ok }
      else
        wants.html { render :action => "edit" }
        wants.xml { render :xml => @result_type.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /result_types/1
  # DELETE /result_types/1.xml
  def destroy
    @result_type.destroy

    respond_to do |wants|
      wants.html { redirect_to(result_types_url) }
      wants.xml { head :ok }
    end
  end

  private

    def find_result_type
      @result_type = ResultType.find(params[:id])
    end

end