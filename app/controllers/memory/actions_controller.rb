class Memory::ActionsController < ApplicationController
  def index
    if params[:range]
      first_number, last_number = params[:range].split('-').map(&:to_i)
      @actions = Memory::Action.at(first_number..last_number)
    else
      @actions = Memory::Action.all
    end
  end
end
