require 'test_helper'

class CreativeWorksControllerTest < ActionController::TestCase
  setup do
    @creative_work = creative_works(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:creative_works)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create creative_work" do
    assert_difference('CreativeWork.count') do
      post :create, creative_work: { created_at: @creative_work.created_at, description: @creative_work.description, name: @creative_work.name, thumbnail: @creative_work.thumbnail, updated_at: @creative_work.updated_at, url: @creative_work.url }
    end

    assert_redirected_to creative_work_path(assigns(:creative_work))
  end

  test "should show creative_work" do
    get :show, id: @creative_work
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @creative_work
    assert_response :success
  end

  test "should update creative_work" do
    patch :update, id: @creative_work, creative_work: { created_at: @creative_work.created_at, description: @creative_work.description, name: @creative_work.name, thumbnail: @creative_work.thumbnail, updated_at: @creative_work.updated_at, url: @creative_work.url }
    assert_redirected_to creative_work_path(assigns(:creative_work))
  end

  test "should destroy creative_work" do
    assert_difference('CreativeWork.count', -1) do
      delete :destroy, id: @creative_work
    end

    assert_redirected_to creative_works_path
  end
end
