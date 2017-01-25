module CheckoutsHelper
  def active_step_class(current_step)
    'active' unless future_step?(current_step)
  end
end
