require "spec_helper"

describe "User connection" do

  context 'with correct parameters' do
    it "connect with the username" do
      user = User.create(:username    => "Test",
                         :email   => "test@test.fr",
                         :password => "ilovegrapes")

      visit "/user/sign_in"

      fill_in "user[login]",    :with => user.username
      fill_in "user[password]", :with => user.password

      click_button "Se connecter"

      page.should have_content(I18n.t('devise.sessions.signed_in'))
    end

    it "connect with the email" do
      user = User.create(:username    => "Test",
                         :email   => "test@test.fr",
                         :password => "ilovegrapes")

      visit "/user/sign_in"

      fill_in "user[login]",    :with => user.email
      fill_in "user[password]", :with => user.password

      click_button "Se connecter"

      page.should have_content(I18n.t('devise.sessions.signed_in'))
    end
  end
end