require "spec_helper"

include Warden::Test::Helpers
Warden.test_mode!

describe "Actions on Profile" do
  let(:user) { FactoryGirl.create :user }
  let(:avatar) { FactoryGirl.create :asset, file: 'test', referencer_id: user.profile.id, referencer_type: "Profile" }

  before(:each) { login_as(user, :scope => :user) }

  context 'edit profile' do
    subject { FactoryGirl.create :profile, user_id: user.id }

    before(:each) do
      visit "/profiles/#{user.slug}/edit"

      fill_in "Nom",    :with => 'Test'
      fill_in "Prénom", :with => 'sdfs'

      click_button "Sauvegarder"
    end
    
    it { find_field('Nom').value.should have_text('Test') }
    it { find_field('Prénom').value.should have_text('sdfs') }
    it { page.should have_text(I18n.t('profile.update.success')) }
  end
end