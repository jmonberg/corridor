require 'test_helper'

class ArticleCommentTest < ActiveSupport::TestCase
  def test_will_create_comment
    d = ArticleComment.create(:article_id => 1, :author => 'Jimmy', :body => 'This article is great')
	assert d.valid?
  end
  def test_should_validate_empty_fields
    d = ArticleComment.create(:article_id => 1, :author => nil, :body => nil)
	assert d.errors.on(:author, :body)
  end
end
