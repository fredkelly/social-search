class Engine
  # Initialises based on supplied <tt>Search</tt> instance.
  def initialize(search)
    10.times do |i|
      search.results.create(
        position: i,
        title: "Something No. #{i+1} about #{search.query}!",
        description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Pellentesque turpis leo, aliquet ut iaculis sed, ornare sit amet nunc. Phasellus et hendrerit velit. Donec iaculis felis quis metus eleifend quis imperdiet libero malesuada.",
        source_engine: self.class.to_s
      )
    end
  end
  
  attr_reader :results
  
  def results<<(result)
    result[:source_engine] = self.class.to_s
    @results << result
  end
end