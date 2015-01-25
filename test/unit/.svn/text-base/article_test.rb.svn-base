require 'test_helper'

class ArticleTest < ActiveSupport::TestCase
  test "should create article" do
    # a = Article.create(:category => 'Transportation', :title => 'Improve Transportation', :author => 'Authormcgee', :body => 'This is the transportation body text', :tags => 'tag', :imglink1 => 'www.google.com', :imglink2 => 'www.yahoo.com', :caption1 => 'google!', :caption2 => 'yahoo!')
    a = create
    assert a.valid?
  end
  
  test "required fields should be filled" do
    a = Article.create
    assert a.errors.on(:title)
    assert a.errors.on(:body)
    assert a.errors.on(:category)
  end

  private
  
  def create(options = {})
    Article.create({
       :title => "Awesome Article",
       :body => "lots of content",
       :category => "Cooperation"
      }.merge(options))
  end
  
  def test_should_increment_votes_counter_cache
    articles(:two).votes.create
    articles(:two).reload
    assert_equal 1, articles(:two).attributes['votes_count']
  end
  
  def test_should_decrement_votes_counter_cache
    articles(:one).votes.first.destroy
    articles(:one).reload
    assert_equal 1, articles(:one).attributes['votes_count']
  end
  
  def test_should_have_a_votes_association
    assert_equal [ votes(:one), votes(:two) ],
      articles(:one).votes
  end
end