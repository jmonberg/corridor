require 'test_helper'

class ArticleCommentsControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:article_comments)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create article_comment" do
    assert_difference('ArticleComment.count') do
      post :create, :article_comment => { }
    end

    assert_redirected_to article_comment_path(assigns(:article_comment))
  end
  
  test "should add new comment" do
	post :create, :article_comment => {
		:article_id => '1',
		:author => 'Name',
		:body => 'Text',
		}
	assert ! assigns(:article_comment).new_record?
	assert_redirected_to_articles_comment_path
	assert_not_nil flash[:notice]
  end
  
  test "should reject missing comment attribute" do
		post :create, :article_comment => { 
		:article_id => '1',
		:body => 'Missing Author',
		}
		assert assigns(:articles_comment).errors.on(:author)
  end

  test "should show article_comment" do
    get :show, :id => article_comments(:one).id
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => article_comments(:one).id
    assert_response :success
  end

  test "should update article_comment" do
    put :update, :id => article_comments(:one).id, :article_comment => { }
    assert_redirected_to article_comment_path(assigns(:article_comment))
  end

  test "should destroy article_comment" do
    assert_difference('ArticleComment.count', -1) do
      delete :destroy, :id => article_comments(:one).id
    end

    assert_redirected_to article_comments_path
  end
end
