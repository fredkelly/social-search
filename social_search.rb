# <tt>Sinatra::Base</tt> application provides
# the HTTP interface for the application.
class SocialSearch < Sinatra::Base
  
  # ENV['RACK_ENV'] specific configuration
  configure :test, :development do
    IS_VERBOSE = true
  end
  configure :production do
    IS_VERBOSE = false
  end
  
  # @method index
  # +root+ or +index+ route, renders the search form.
  get '/' do
    erb :search
  end
  
  # @method google
  # demonstration of the Google 'white label' system.
  get '/google' do
    @results = Google.search(params[:q])
    
    erb :results # make generic!
  end
  
  # @method search
  # +search+ operation, calls the clustering
  # algorithm using the specified query term.
  #
  # @param [String] q The query string, e.g. 'Olympics 2012'
  #
  get '/search' do
    @results = k_means(params[:q])
    
    erb :results
  end
  
  # @method mixed
  # calls two search providers for a given
  # query and combines the results into a
  # single results set (randomly).
  #
  # @param [String] q The query string, e.g. 'Olympics 2012'
  #
  get '/mixed' do
    @results = k_means(params[:q]) + Google.search(params[:q])
    
    erb :results
  end
  
  # @method manual_form
  # Provides interface to manual clustering for
  # testing/development purposes only.
  #
  # Renders the manual classification view
  # until all samples have been clustered.
  #
  # @param [String] q The query string, e.g. 'Olympics 2012'
  # @param [Fixnum] k K value to supply to <tt>ManualClusterer</tt>.
  # @param [String] stash Local file path to save classification data to.
  #
  get '/manual' do
    # if we can't load the existing clusters..
    unless @clusterer = ManualClusterer.load(params[:stash])
      # get new samples from twitter, and create clusters
      samples = Twitter.search(params[:q], rpp: 100)
      @clusterer = ManualClusterer.new(samples, :k => params[:k].to_i)
    end
    
    # save back to specified path
    @clusterer.save(params[:stash]) if params[:stash]
    
    # grab remaining samples
    @samples = @clusterer.remaining_samples
    
    # have we finished classifying?
    erb @samples.empty? ? :results : :manual
  end
  
  # @method manual_submit
  # Recieves array of truth labels from POST request.
  # Loads up the clusterer instance from given path
  # and applies the supplied labels to the contained samples.
  #
  # @param [Fixnum] k K value to supply to <tt>ManualClusterer</tt>.
  # @param [String] stash Local file path to save classification data to.
  #
  post '/manual' do
    # reload the saved cluster obj
    @clusterer = ManualClusterer.load(params[:stash])
    
    # perform clustering using labels
    @clusterer.cluster!(to_ints(params[:labels]))
    
    # save to file
    @clusterer.save
    
    erb :results
  end
  
  private
  
  # @method k_means
  # Helper method to do the heavy lifting
  # when calling the KMeans clusterer.
  #
  # @param [String] query The query string, e.g. 'Olympics 2012'
  #
  def k_means(query)
    # get new samples from twitter, and create clusterer
    samples = Twitter.search(query, rpp: 100)
    
    clusterer = KMeans.new(samples,
                 :k => 5,
                 :threshold => 0.95,
                 :iterations => 1,
                 :verbose => IS_VERBOSE
               )
    
    # perform clustering
    clusterer.cluster!
    
    # fetch results
    clusterer.results
  end
  
  # @method to_ints
  # Helper method to convert key/values to integers.
  # e.g. from params[:labels], each key and value
  # is converted to an integet using +to_i+ then rehashed.
  #
  # @param [Hash] hash The hash to be converted.
  #
  def to_ints(hash)
    Hash[*hash.to_a.flatten.map(&:to_i)]
  end
  
end