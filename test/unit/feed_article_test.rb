require 'test_helper'
# All tests stored alphabetically
# NOTE: Failed to create a test that could save a valid Feed Article.
# This made it difficult (impossible?) to test saving an *invalid* Feed Article.

class FeedArticleTest < ActiveSupport::TestCase

  # We should be able to save a valid Feed Article
  test "save valid feed article" do

    # Find the 2nd feed from the test fixture (sample data used during testing) 
    # We'll use the Feed ID for the new Feed Article
    f = feeds(:two)
    f.save
    assert f.valid?, "Failed to save a valid Feed from fixture data"
    assert_equal(f.id, 996332877, "Feed ID is: " + f.id.to_s)

    fa = FeedArticle.create( :title => "Feed Article Title" , 
                             :content  => "Feed Article Content goes here!", 
                             :permalink  => "https://www.msu.edu/~perlstad/index.htm",
                             :date_posted => 2009-03-06,
                             :feed_id => f.id )

#     assert fa.valid?, "Failed to save a valid Feed Article"
     assert fa.valid?, f.id

    # Cleanup after ourselves
    f.destroy
  end



  # Required Fields: content, date_posted, title 

  # Create/save a new Feed Article without a title
#  test "fail without title" do
#    fa = FeedArticle.create( :title => nil, 
#                             :content  => "http://news.msu.edu/topic/6/", 
#                             :permalink  => "http://news.msu.edu/rss/3/arts_and_humanities/",
#                             :date_posted = > 2009-03-05 )
#    # Look for errors on the site_name field
#    assert fa.errors.on( :title ), "Failed on missing Title"
#  end

end