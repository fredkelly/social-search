
n.n.n / 2013-02-08 
==================

  * A little CSS, added URL truncating and propogating via NET::HTTP
  * Added basic scraping logic using HTTParty & Nokogiri.
  * Result class with Engine stub. Clicks being tracked from results page, reliant on jQuery at the moment.
  * Removed Rails default index.html
  * Added Session/Search models, need to add Results and generate.
  * Blank Rails App.
  * Initial commmit.
  * Added /doc to .gitignore
  * Added quick provider toggle for testing.
  * Push /doc to heroku
  * Updated exception truncate method.
  * Removed /doc from .gitignore for Heroku.
  * Added symlink to /doc in /public, hoping this will allow access via Heroku?
  * Updated Yardoc for HtmlParserIncluded, Page & Twitter classes.
  * Removed profiling for Heroku.
  * Removed array split from description.
  * Refactoring of Page/Result class, got rid of duplication.
  * cover-up for Google bold in descriptions.
  * cover-up for Google bold in descriptions.
  * added require to clusterer sub-classes
  * added require to clusterer sub-classes
  * added require to clusterer sub-classes
  * added require to clusterer sub-classes
  * Heroku push 19-11-2012
  * Sorting of results by cluster size, updated documentation.
  * More robust parsing of result descriptions.
  * Updated Clusters to form Result instances using the same results.erb view, needs more refactoring still.
  * Hacked together Google/Kmeans results pages - needs plenty of work.
  * Added super-simple Google search wrapper.
  * Wrote tests for Clusterer.
  * Fixed array size issue when passing k value to ManualClusterer.
  * Added Clusterer.remaining_samples method for web form - this whole process needs looking at properly and possibly refactoring...Could move ManualClassification into a CLI module?
  * Added comment to compare_to delta calculation.
  * Build basic rating/comparison score method in ManualClusterer.compare_to()
  * Added documentation (yard), test rig (classifier_test.rb), and loads of other changes.
  * Good, bad & ugly..
  * Refinements on comparison (untested).
  * Tided some methods up a little.
  * Untested comparison method based on pseudocode.
  * Removed /stash from repo.
  * Updated .gitignore
  * Converted Cluster to inherit from Set.
  * More work on test set, spec for comparison algorithm.
  * Updated .gitignore
  * Storing of Clustering objects.
  * Cleaned up old files.
  * Renamed Classifier to Clusterer, started building layout.erb.
  * Added manual classification.
  * Added storing of results arrays.
  * Merge branch 'master' of github.com:fredkelly/social-search
  * Initial test rig.
  * Initial commit
