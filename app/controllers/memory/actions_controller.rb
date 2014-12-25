class Memory::ActionsController < ApplicationController
  include DurationParamsBuildable
  helper_method :first_param, :last_param

  def index
    if params[:first] && params[:last]
      @actions = Memory::Action.at(first_param..last_param)
    else
      @actions = Memory::Action.all
    end
  end
end
