require "test_helper"

class ReferralLinksControllerTest < ActionDispatch::IntegrationTest
  test "should get redirect" do
    get referral_links_redirect_url
    assert_response :success
  end
end
