module DurationParamsBuildable
  def first_param
    params[:first].try(&:to_i) || 0
  end

  def last_param
    return @last_param if @last_param

    @last_param = params[:last].try(&:to_i) || 9
    if @last_param <= first_param
      @last_param = first_param + 9
    end
    @last_param
  end
end
