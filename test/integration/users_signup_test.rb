require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest

  test 'invalid signup information' do
    get signup_path
    assert_select 'form[action="/signup"]', count: 1
    assert_no_difference 'User.count' do
      post signup_path, params: { user: { name: '',
                                          email: 'user@invalid',
                                          password: 'foo',
                                          password_confirmation: 'bar' } }
    end
    assert_template 'users/new'
    assert_select 'div#error_explanation'
    assert_select 'div.field_with_errors', count: 8
  end

  test 'valid signup information' do
    get signup_path
    assert_select 'form[action="/signup"]', count: 1
    assert_difference 'User.count', 1 do
      post signup_path, params: { user: { name: 'Martin Martin',
                                          email: 'example@example.com',
                                          password: 'foobar',
                                          password_confirmation: 'foobar' } }
    end
    follow_redirect!
    assert_template 'users/show'
    assert_not flash[:success].empty?
    assert is_logged_in?
  end
end
