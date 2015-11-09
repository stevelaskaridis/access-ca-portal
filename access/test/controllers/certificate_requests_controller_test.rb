require 'test_helper'

class CertificateRequestsControllerTest < ActionController::TestCase
  setup do
    @certificate_request = certificate_requests(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:certificate_requests)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create certificate_request" do
    assert_difference('CertificateRequest.count') do
      post :create, certificate_request: {  }
    end

    assert_redirected_to certificate_request_path(assigns(:certificate_request))
  end

  test "should show certificate_request" do
    get :show, id: @certificate_request
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @certificate_request
    assert_response :success
  end

  test "should update certificate_request" do
    patch :update, id: @certificate_request, certificate_request: {  }
    assert_redirected_to certificate_request_path(assigns(:certificate_request))
  end

  test "should destroy certificate_request" do
    assert_difference('CertificateRequest.count', -1) do
      delete :destroy, id: @certificate_request
    end

    assert_redirected_to certificate_requests_path
  end
end
