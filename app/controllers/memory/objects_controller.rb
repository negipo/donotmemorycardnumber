class Memory::ObjectsController < ApplicationController
  include DurationParamsBuildable
  helper_method :first_param, :last_param

  def index
    if params[:first] && params[:last]
      @objects = Memory::Object.at(first_param..last_param)
    else
      @objects = Memory::Object.all
    end
  end
end
