require 'test_helper'

class VoteControllerTest < ActionController::TestCase
  test "the truth" do
    assert true
  end
  
  def test_should_accept_vote
    assert articles(:two).votes.empty?
    post :create, :article_id => articles(:two)
    assert ! assigns(:article).votes.empty?
  end
  
  def test_should_render_rjs_after_vote_with_ajax
    xml_http_request :post, :create, :article_id => articles(:two)
    assert_response :success
    assert_template 'create'
  end
  
  def test_should_redirect_after_vote_with_http_post
    post :create, :article_id => articles(:two)
    assert_redirected_to article_path(articles(:two))
  end
end
