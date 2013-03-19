Enumerable.class_eval do
  def mode
    group_by{|e| e}.values.max_by(&:size).first
  end
  
  def mean
    reduce(&:+).to_f / size
  end
end