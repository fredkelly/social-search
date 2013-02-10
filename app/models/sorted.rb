

class Sorted < Engine
  
  SCRAPED = true
  
  SEARCH_OPTS = {
    rpp: 100,
    lang: :en,
    result_type: :mixed
  }
  
  def initialize(search)
    @samples = search(search.query).results.sort
    Rails.logger.info @samples.map{|r| r.text + "\n\t" + r.tokens.join(',') + "\n\t" + r.urls.map(&:url).join(',') }.join("\n")
      
    i = 0
    previous = nil
    @clusters = []
    
    # perform clustering
    @samples.each do |current|
      (@clusters[i] ||= []) << current
      unless previous.nil? or Sorted.distance(previous, current) < 0.75
        i += 1
        Rails.logger.info "Starting a new cluster between \"#{previous.tokens.join(',')}\" and \"#{current.tokens.join(',')}\"."
      end
      previous = current
    end
    
    # generate search results
    @clusters.sort_by(&:size).each_with_index do |cluster, position| 
      url = cluster.map(&:expanded_urls).flatten.mode # most frequently occuring url
      unless url.nil?
        begin
          search.results.create(
            source_engine: self.class, url: url, position: position
          )
        rescue Exception => error
          Rails.logger.info "Skipped a cluster!.. #{error}."
          position -= 1 # skip count
        end
      end
    end
    
  end
  
  def search(query)
    # searches for tweets containing links (excl. retweets)
    @search ||= Twitter.search("#{URI::escape(query)} filter:links +exclude:retweets", SEARCH_OPTS)
  end
  
  def self.distance(first, second)
    return 0 if first.tokens.empty? || second.tokens.empty?
    1.0 - (first.tokens & second.tokens).size.to_f / (first.tokens + second.tokens).size
  end
  
end

# added methods for tokenisation etc.
class Twitter::Tweet
  
  STOP_WORDS = ['a', 'cannot', 'into', 'our', 'thus', 'about', 'co', 'is', 'ours', 'to', 'above', 'could', 'it', 'ourselves', 'together', 'across', 'down', 'its', 'out', 'too', 'after', 'during', 'itself', 'over', 'toward', 'afterwards', 'each', 'last', 'own', 'towards', 'again', 'eg', 'latter', 'per', 'under', 'against', 'either', 'latterly', 'perhaps', 'until', 'all', 'else', 'least', 'rather', 'up', 'almost', 'elsewhere', 'less', 'same', 'upon', 'alone', 'enough', 'ltd', 'seem', 'us', 'along', 'etc', 'many', 'seemed', 'very', 'already', 'even', 'may', 'seeming', 'via', 'also', 'ever', 'me', 'seems', 'was', 'although', 'every', 'meanwhile', 'several', 'we', 'always', 'everyone', 'might', 'she', 'well', 'among', 'everything', 'more', 'should', 'were', 'amongst', 'everywhere', 'moreover', 'since', 'what', 'an', 'except', 'most', 'so', 'whatever', 'and', 'few', 'mostly', 'some', 'when', 'another', 'first', 'much', 'somehow', 'whence', 'any', 'for', 'must', 'someone', 'whenever', 'anyhow', 'former', 'my', 'something', 'where', 'anyone', 'formerly', 'myself', 'sometime', 'whereafter', 'anything', 'from', 'namely', 'sometimes', 'whereas', 'anywhere', 'further', 'neither', 'somewhere', 'whereby', 'are', 'had', 'never', 'still', 'wherein', 'around', 'has', 'nevertheless', 'such', 'whereupon', 'as', 'have', 'next', 'than', 'wherever', 'at', 'he', 'no', 'that', 'whether', 'be', 'hence', 'nobody', 'the', 'whither', 'became', 'her', 'none', 'their', 'which', 'because', 'here', 'noone', 'them', 'while', 'become', 'hereafter', 'nor', 'themselves', 'who', 'becomes', 'hereby', 'not', 'then', 'whoever', 'becoming', 'herein', 'nothing', 'thence', 'whole', 'been', 'hereupon', 'now', 'there', 'whom', 'before', 'hers', 'nowhere', 'thereafter', 'whose', 'beforehand', 'herself', 'of', 'thereby', 'why', 'behind', 'him', 'off', 'therefore', 'will', 'being', 'himself', 'often', 'therein', 'with', 'below', 'his', 'on', 'thereupon', 'within', 'beside', 'how', 'once', 'these', 'without', 'besides', 'however', 'one', 'they', 'would', 'between', 'i', 'only', 'this', 'yet', 'beyond', 'ie', 'onto', 'those', 'you', 'both', 'if', 'or', 'though', 'your', 'but', 'in', 'other', 'through', 'yours', 'by', 'inc', 'others', 'throughout', 'yourself', 'can', 'indeed', 'otherwise', 'thru', 'yourselves']
  
  # WIP
  def tokens
    # ignores case, removes URLs and stop-words then stems.
    @tokens ||= (text_only.downcase.scan(/\b(\w+)\b/).flatten.reject{|t| t.size < 3} - STOP_WORDS).map(&:stem)
  end
  
  def <=>(other)
    tokens <=> other.tokens
  end
  
  def expanded_urls
    urls.map(&:expanded_url)
  end
  
  private
  
  def text_only
    # removes any URLs
    @text_only ||= text.gsub(/(?:f|ht)tps?:\/[^\s]+/, '')
  end
  
end

Enumerable.class_eval do
  def mode
    group_by do |e|
      e
    end.values.max_by(&:size).first
  end
end