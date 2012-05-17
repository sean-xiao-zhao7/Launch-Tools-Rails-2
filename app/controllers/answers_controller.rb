class AnswersController < ApplicationController

filter_resource_access

def show
  @answer = Answer.find(params[:id])
end

end
