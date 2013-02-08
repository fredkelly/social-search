class Engine
  # Ugly demo of how results should be generated (roughly);
  # initialises based on supplied <tt>Search</tt> instance.
  def initialize(search)
    10.times do |position|
      search.results.create(
        position: position, title: "Something No. #{position+1} about #{search.query}!",
        description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Pellentesque turpis leo, aliquet ut iaculis sed, ornare sit amet nunc. Phasellus et hendrerit velit. Donec iaculis felis quis metus eleifend quis imperdiet libero malesuada.",
        source_engine: self.class, url: 'http://google.co.uk/'
      )
    end
  end
end