require 'test_helper'

class UsermailerTest < ActionMailer::TestCase
  test "account_activation" do
    user = users(:valentino)
    user.activation_token = User.new_token
    mail = Usermailer.account_activation(user)
    assert_equal "Account activation", mail.subject
    assert_equal [user.email], mail.to
    assert_equal ["noreply@example.com"], mail.from
    assert_match user.name, mail.body.encoded
    assert_match user.activation_token, mail.body.encoded
    assert_match CGI::escape(user.email), mail.body.encoded
  end

 test "password_reset" do
  user = users(:valentino)
  user.reset_token = User.new_token
  mail = Usermailer.password_reset(user)
  assert_equal "Password reset", mail.subject
  assert_equal [user.email], mail.to
  assert_equal ["noreply@example.com"], mail.from
  assert_match user.reset_token, mail.body.encoded
  assert_match CGI::escape(user.email), mail.body.encoded
 end

end
