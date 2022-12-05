require 'test_helper'

class FixturesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @fixture = fixtures(:one)
  end

  test "should get index" do
    get fixtures_url
    assert_response :success
  end

  test "should get new" do
    get new_fixture_url
    assert_response :success
  end

  test "should create fixture" do
    assert_difference('Fixture.count') do
      post fixtures_url, params: { fixture: { away_id: @fixture.away_id, channel: @fixture.channel, date: @fixture.date, home_id: @fixture.home_id, session: @fixture.session } }
    end

    assert_redirected_to fixture_url(Fixture.last)
  end

  test "should show fixture" do
    get fixture_url(@fixture)
    assert_response :success
  end

  test "should get edit" do
    get edit_fixture_url(@fixture)
    assert_response :success
  end

  test "should update fixture" do
    patch fixture_url(@fixture), params: { fixture: { away_id: @fixture.away_id, channel: @fixture.channel, date: @fixture.date, home_id: @fixture.home_id, session: @fixture.session } }
    assert_redirected_to fixture_url(@fixture)
  end

  test "should destroy fixture" do
    assert_difference('Fixture.count', -1) do
      delete fixture_url(@fixture)
    end

    assert_redirected_to fixtures_url
  end
end
