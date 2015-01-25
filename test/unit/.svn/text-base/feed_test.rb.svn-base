require 'test_helper'
# All tests stored alphabetically

class FeedTest < ActiveSupport::TestCase
  # Create/save a new feed record without a feed url
  # BROKEN TEST: Throws error
  test "fail on invalid feed_url" do
    f = Feed.create( :site_name => "MSU Arts and Humanities", 
                     :site_url  => "http://news.msu.edu/topic/6/", 
                     :feed_url  => "hhhttttpp://news.msu.edu/rss/3/arts_and_humanities/" )
    # Look for errors on the site_name field
    assert f.errors.on( :feed_url ), "Failed on invalid Feed URL"
  end

  # Create/save a new feed record without a feed url
  # BROKEN TEST: Throws error
  test "fail without feed_url" do
    f = Feed.create( :site_name => "MSU Arts and Humanities", 
                     :site_url  => "http://news.msu.edu/topic/6/", 
                     :feed_url  => nil )
    # Look for errors on the site_name field
    assert f.errors.on( :feed_url ), "Failed on missing Feed URL"
  end

  # Create/save a new feed record without a site name
  test "fail without site_name" do
    f = Feed.create( :site_name => nil, 
                     :site_url  => "http://news.msu.edu/topic/6/", 
                     :feed_url  => "http://news.msu.edu/rss/3/arts_and_humanities/" )
    # Look for errors on the site_name field
    # assert f.errors.on( :site_name )
    assert f.errors.on( :site_name ), "Failed on missing Site Name"
  end

  # Create/save a new feed record without a site url
  test "fail without site_url" do
    f = Feed.create( :site_name => "MSU Arts and Humanities", 
                     :site_url  => nil, 
                     :feed_url  => "http://news.msu.edu/rss/3/arts_and_humanities/" )
    # Look for errors on the site_name field
    assert f.errors.on( :site_url )
  end

  # Check for the existance of the after_save method
  test "method exists after_save" do
    f = Feed.new()
    assert_respond_to( f, :after_save, "'after_save' Method is missing" )
  end

  # Check for the existance of the Pull method
  test "method exists pull" do
    f = Feed.new()
    assert_respond_to( f, :pull, "'Pull' Method is missing" )
  end

  # Check for the existance of the Validate method
  test "method exists validate" do
    f = Feed.new()
    assert_respond_to( f, :validate, "'Validate' Method is missing" )
  end

  # We should be able to save a valid Feed
  test "save valid Feed" do
    f = Feed.create( :site_name => "MSU Business, Economy, Law and Communications" , 
                     :site_url  => "http://news.msu.edu/topic/6/", 
                     :feed_url  => "http://news.msu.edu/rss/6/business_economy_law_and_communications/" )    
    assert f.valid?, "Failed to save a valid Feed"
    f.destroy
  end

  test "save valid Feed from fixture data" do
    # Find the 2nd feed from the test fixture (sample data used during testing) 
    # We'll use the Feed ID for the new Feed Article
    f = feeds(:two)
    f.save
    assert f.valid?, "Failed to save a valid Feed from fixture data"
    f.destroy
  end
end