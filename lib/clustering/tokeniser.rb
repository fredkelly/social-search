module Clustering
  class Tokeniser
    
    OPTIONS = {
      lang: :en,
      limit: 5,
      stem: false,
      downcase: true,
      remove_stopwords: true,
      keep_only_tags: %w(NN NNP NNPS NNS VB VBD VBG VBN VBP VBZ)
    }
    
    STOP_WORDS = ['rt', 'a', 'cannot', 'into', 'our', 'thus', 'about', 'co', 'is', 'ours', 'to', 'above', 'could', 'it', 'ourselves', 'together', 'across', 'down', 'its', 'out', 'too', 'after', 'during', 'itself', 'over', 'toward', 'afterwards', 'each', 'last', 'own', 'towards', 'again', 'eg', 'latter', 'per', 'under', 'against', 'either', 'latterly', 'perhaps', 'until', 'all', 'else', 'least', 'rather', 'up', 'almost', 'elsewhere', 'less', 'same', 'upon', 'alone', 'enough', 'ltd', 'seem', 'us', 'along', 'etc', 'many', 'seemed', 'very', 'already', 'even', 'may', 'seeming', 'via', 'also', 'ever', 'me', 'seems', 'was', 'although', 'every', 'meanwhile', 'several', 'we', 'always', 'everyone', 'might', 'she', 'well', 'among', 'everything', 'more', 'should', 'were', 'amongst', 'everywhere', 'moreover', 'since', 'what', 'an', 'except', 'most', 'so', 'whatever', 'and', 'few', 'mostly', 'some', 'when', 'another', 'first', 'much', 'somehow', 'whence', 'any', 'for', 'must', 'someone', 'whenever', 'anyhow', 'former', 'my', 'something', 'where', 'anyone', 'formerly', 'myself', 'sometime', 'whereafter', 'anything', 'from', 'namely', 'sometimes', 'whereas', 'anywhere', 'further', 'neither', 'somewhere', 'whereby', 'are', 'had', 'never', 'still', 'wherein', 'around', 'has', 'nevertheless', 'such', 'whereupon', 'as', 'have', 'next', 'than', 'wherever', 'at', 'he', 'no', 'that', 'whether', 'be', 'hence', 'nobody', 'the', 'whither', 'became', 'her', 'none', 'their', 'which', 'because', 'here', 'noone', 'them', 'while', 'become', 'hereafter', 'nor', 'themselves', 'who', 'becomes', 'hereby', 'not', 'then', 'whoever', 'becoming', 'herein', 'nothing', 'thence', 'whole', 'been', 'hereupon', 'now', 'there', 'whom', 'before', 'hers', 'nowhere', 'thereafter', 'whose', 'beforehand', 'herself', 'of', 'thereby', 'why', 'behind', 'him', 'off', 'therefore', 'will', 'being', 'himself', 'often', 'therein', 'with', 'below', 'his', 'on', 'thereupon', 'within', 'beside', 'how', 'once', 'these', 'without', 'besides', 'however', 'one', 'they', 'would', 'between', 'i', 'only', 'this', 'yet', 'beyond', 'ie', 'onto', 'those', 'you', 'both', 'if', 'or', 'though', 'your', 'but', 'in', 'other', 'through', 'yours', 'by', 'inc', 'others', 'throughout', 'yourself', 'can', 'indeed', 'otherwise', 'thru', 'yourselves']
    
    # Singleton
    def self.instance
      @@instance ||= new
    end
    
    # initializes with (custom) options hash
    def initialize(options = nil)
      @options = options || OPTIONS
      @options[:limit] ||= 5
      
      if @options.has_key?(:keep_only_tags)
        require 'engtagger'
        @tagger = EngTagger.new
      end
    end

    # perfoms the tokenisation
    def tokenise(passage)      
      passage = keep_only_tags(passage, @options[:keep_only_tags]) if @options[:keep_only_tags]
      tokens  = passage.scan(/[a-zA-Z]+/).reject{|t| t.size < @options[:limit]}
      tokens  = tokens.map(&:downcase) if @options[:downcase]
      tokens  = tokens - STOP_WORDS if @options[:remove_stopwords]
      tokens  = tokens.map(&:stem) if @options[:stem]
            
      tokens
    end
    
    # destructive tokeniser
    def tokenise!(passage)
      passage = tokenise(passage)
    end
    
    private
    
    # POS selective removal
    # left tags as an argument to allow reuse later
    def keep_only_tags(passage, tags = %w(NNP NN VB))
      raise "invalid tag/s supplied" unless (tags.map(&:downcase) - EngTagger::TAGS.keys).empty?
      @tagger.get_hashed(passage).delete_if{|tag,tokens| !tags.include?(tag)}.values.join(' ')
    end
    
  end
end