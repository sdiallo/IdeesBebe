require "spec_helper"

describe "User registration" do

  context 'with correct parameters' do

    it 'register' do
      visit "/user/sign_up"

      within("form#new_user") do
        fill_in "user[username]", :with => "Test"
        fill_in "user[email]", :with => "alindeman@example.com"
        fill_in "user[password]", :with => "ilovegrapes"
        fill_in "user[password_confirmation]", :with => "ilovegrapes"
      end
      click_button "S'inscrire"
      page.should have_content(I18n.t('devise.registrations.signed_up'))
    end
  end

  context 'with incorrect parameters' do

    it "doesn't allow register without username" do
      visit "/user/sign_up"

      within("form#new_user") do
        fill_in "user[username]", :with => ""
        fill_in "user[email]", :with => "alindeman@example.com"
        fill_in "user[password]", :with => "ilovegrapes"
        fill_in "user[password_confirmation]", :with => "ilovegrapes"
      end
      click_button "S'inscrire"

      page.should have_content(I18n.t('user.username.presence'))
    end

    it "doesn't allow register without email" do
      visit "/user/sign_up"

      within("form#new_user") do
        fill_in "user[username]", :with => "Test"
        fill_in "user[email]", :with => ""
        fill_in "user[password]", :with => "ilovegrapes"
        fill_in "user[password_confirmation]", :with => "ilovegrapes"
      end
      click_button "S'inscrire"

      page.should have_content(I18n.t('activerecord.errors.models.user.attributes.email.blank'))
    end
  end
end