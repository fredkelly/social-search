Enumerable.class_eval do
  def mode
    return first if size < 3
    group_by do |e|
      e
    end.values.max_by(&:size).first
  end
end