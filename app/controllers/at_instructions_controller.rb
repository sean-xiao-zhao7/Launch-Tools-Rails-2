class AtInstructionsController < ApplicationController
  before_filter :set_at_instruction, :only => [:edit, :update]

  # GET /at_instructions/1/edit
  def edit
  end

  # POST /at_instructions
  # POST /at_instructions.xml
  def create
    @at_instruction = AtInstruction.new(params[:at_instruction])

    respond_to do |wants|
      if @at_instruction.save
        flash[:success] = 'The instructions were successfully saved.'
        wants.html { redirect_to assessment_path(@assessment) }
        wants.xml { render :xml => @at_instruction, :status => :created, :location => @at_instruction }
      else
        wants.html { render :action => "edit" }
        wants.xml { render :xml => @at_instruction.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /at_instructions/1
  # PUT /at_instructions/1.xml
  def update
    respond_to do |wants|
      if @at_instruction.update_attributes(params[:at_instruction])
        flash[:success] = 'The instructions were successfully saved.'
        wants.html { redirect_to assessment_path(@assessment) }
        wants.xml { head :ok }
      else
        wants.html { render :action => "edit" }
        wants.xml { render :xml => @at_instruction.errors, :status => :unprocessable_entity }
      end
    end
  end

  private

    def set_at_instruction
      @assessment = Assessment.find(params[:id])
      if @assessment.instruction.nil?
        @at_instruction = AtInstruction.new
        @at_instruction.assessment_id = @assessment.id
      else
        @at_instruction = @assessment.instruction
      end
    end

end