require 'rails_helper'

RSpec.feature 'Users managing organisations' do
  let(:user) { create(:user) }
  let!(:organisation) { create(:organisation, :with_profiles_and_users, profile_count: 3) }

  before do
    login_as_user user.email
  end

  specify 'can view a list of all organisations' do
    visit organisations_path
    expect(page).to have_content "Organisations"
    expect(page).to have_content organisation.name
  end

  specify 'can create a new organisation' do
    visit organisations_path

    click_link "New Organisation"

    fill_in "Name", with: "Imperial College London"
    fill_in "Slug", with: "imperial-college-london"
    fill_in "Organisation type", with: "social"
    check "Searchable"
    fill_in "Tel", with: "09011105010"
    fill_in "Address", with: "123 Fake Street"
    fill_in "Postcode", with: "POSTCODE"
    fill_in "Email", with: "imperial@example.com"

    click_button "Create Organisation"

    expect(page).to have_content "Organisation successfully created"
    expect(page).to have_content "Imperial College London"

    within '#imperial-college-london-row' do
      click_link "Show"
    end

    expect(page).to have_content "Name: Imperial College London"
    expect(page).to have_content "Slug: imperial-college-london"
    expect(page).to have_content "Tel: 09011105010"
    expect(page).to have_content "Address: 123 Fake Street"
    expect(page).to have_content "Postcode: POSTCODE"
    expect(page).to have_content "Email: imperial@example.com"
  end

  specify 'are shown errors if an organisation cannot be created' do
    visit organisations_path

    click_link "New Organisation"

    fill_in "Name", with: "LRUG"
    fill_in "Slug", with: "london-ruby-users-group"

    click_button "Create Organisation"

    expect(page).to have_content "You need to fix the errors on this page before continuing"
    expect(page).to have_content "Organisation type: can't be blank"
  end

  specify 'can delete an organisation' do
    visit organisations_path

    click_link 'Delete'

    expect(page).to have_content 'Organisation successfully deleted'
    expect(page).to_not have_content organisation.name
  end

  specify 'are shown errors if an organisation cannot be deleted' do
    visit organisations_path

    organisation_cannot_be_destroyed_for_some_reason organisation
    click_link 'Delete'

    expect(page).to have_content 'Organisation was not deleted'
    expect(page).to have_content organisation.name
  end

  specify 'can edit relevant details for the organisation' do
    visit organisations_path

    click_link 'Edit'
    fill_in "Name", with: "Ministry of Justice"
    fill_in "Slug", with: "ministry-of-justice"
    fill_in "Tel", with: "09011105010"
    fill_in "Address", with: "Somewhere"
    fill_in "Postcode", with: "555 PQ45"
    fill_in "Email", with: "moj@example.com"

    click_button 'Update Organisation'

    expect(page).to have_content "Organisation successfully updated"
    expect(page).to have_content "Ministry of Justice"

    click_link "Show"

    expect(page).to have_content "Name: Ministry of Justice"
    expect(page).to have_content "Slug: ministry-of-justice"
    expect(page).to have_content "Tel: 09011105010"
    expect(page).to have_content "Address: Somewhere"
    expect(page).to have_content "Postcode: 555 PQ45"
    expect(page).to have_content "Email: moj@example.com"
  end

  specify 'are shown errors if invalid details are entered' do
    visit organisations_path

    click_link 'Edit'
    fill_in "Organisation type", with: ""
    click_button 'Update Organisation'

    expect(page).to have_content "You need to fix the errors on this page before continuing"
    expect(page).to have_content "Organisation type: can't be blank"
  end

  specify 'can view relevant details on a show page' do
    visit organisations_path

    click_link 'Show'

    expect(page).to have_content 'Name: NAMBLA'
    expect(page).to have_content 'Slug: north-american-marlon-brando-lookalikes'
    expect(page).to have_content 'Organisation type: social'
    expect(page).to have_content 'Searchable: true'

    expect(page).to have_content 'Members'
    organisation.profiles.each do |p|
      expect(page).to have_content p.name
    end
  end
end

def organisation_cannot_be_destroyed_for_some_reason organisation
  expect(Organisation).to receive(:find).with(organisation.id.to_s) { organisation }
  expect(organisation).to receive(:destroy) { false }
end
