require 'test_helper'

class ArticlesControllerTest < ActionController::TestCase
  def test_should_get_index
    get :index
    assert_response :success
	assert_template 'index'
    assert_not_nil assigns(:articles)
  end

  def test_should_get_new
    get :new
    assert_response :success
	assert_template 'new'
  end

  test "should create article" do
    assert_difference('Article.count') do
      post :create, :article => { }
    end

    assert_redirected_to article_path(assigns(:article))
  end

  test "should show article" do
    get :show, :id => articles(:one).id
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => articles(:one).id
    assert_response :success
  end

  test "should update article" do
    put :update, :id => articles(:one).id, :article => { }
    assert_redirected_to article_path(assigns(:article))
  end

  test "should destroy article" do
    assert_difference('Article.count', -1) do
      delete :destroy, :id => articles(:one).id
    end

    assert_redirected_to articles_path
  end
  
  test "should add new article" do
	post :create, :article => {
		:category => 'Transportation',
		:title => 'New',
		:author => 'Name',
		:body => 'Text',
		:imglink1 => 'URL1',
		:caption1 => 'Caption1',
		:imglink2 => 'URL2',
		:caption2 => 'Caption2',
		}
	assert ! assigns(:article).new_record?
	assert_redirected_to_articles_path
	assert_not_nil flash[:notice]
  end
  
  test "should reject missing story attribute" do
	post :create, :article => { 
		:category => 'Transportation',
		:title => 'Missing body',
		:author => 'Author',
		:imglink1 => 'URL1',
		:caption1 => 'Caption1',
		:imglink2 => 'URL2',
		:caption2 => 'Caption2',
		}
		assert assigns(:articles).errors.on(:body)
  end
end
