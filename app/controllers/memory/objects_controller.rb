class Memory::ObjectsController < ApplicationController
  def index
    if params[:range]
      first_number, last_number = params[:range].split('-').map(&:to_i)
      @objects = Memory::Object.at(first_number..last_number)
    else
      @objects = Memory::Object.all
    end
  end
end
