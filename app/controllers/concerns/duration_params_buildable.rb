module DurationParamsBuildable
  def first_param
    params[:first].try(&:to_i) || 0
  end

  def last_param
    params[:last].try(&:to_i) || 9
  end
end
