class Memory::ObjectsController < ApplicationController
  def index
    first_number, last_number = params[:range].split('-').map(&:to_i)
    @objects = Memory::Object.at(first_number..last_number)
  end
end
