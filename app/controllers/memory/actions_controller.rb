class Memory::ActionsController < ApplicationController
  def index
    first_number, last_number = params[:range].split('-').map(&:to_i)
    @actions = Memory::Action.at(first_number..last_number)
  end
end
