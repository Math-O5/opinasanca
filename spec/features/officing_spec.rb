require 'rails_helper'
require 'sessions_helper'

feature 'Poll Officing' do
  let(:user) { create(:user) }

  scenario 'Access as regular user is not authorized' do
    login_as(user)
    visit root_path

    expect(page).to_not have_link("Polling officers")
    visit officing_root_path

    expect(current_path).not_to eq(officing_root_path)
    expect(current_path).to eq(root_path)
    expect(page).to have_content "You do not have permission to access this page"
  end

  scenario 'Access as moderator is not authorized' do
    create(:moderator, user: user)
    login_as(user)
    visit root_path

    expect(page).to_not have_link("Polling officers")
    visit officing_root_path

    expect(current_path).not_to eq(officing_root_path)
    expect(current_path).to eq(root_path)
    expect(page).to have_content "You do not have permission to access this page"
  end

  scenario 'Access as manager is not authorized' do
    create(:manager, user: user)
    login_as(user)
    visit root_path

    expect(page).to_not have_link("Polling officers")
    visit officing_root_path

    expect(current_path).not_to eq(officing_root_path)
    expect(current_path).to eq(root_path)
    expect(page).to have_content "You do not have permission to access this page"
  end

  scenario 'Access as a valuator is not authorized' do
    create(:valuator, user: user)
    login_as(user)
    visit root_path

    expect(page).to_not have_link("Polling officers")
    visit officing_root_path

    expect(current_path).not_to eq(officing_root_path)
    expect(current_path).to eq(root_path)
    expect(page).to have_content "You do not have permission to access this page"
  end

  scenario 'Access as an poll officer is authorized' do
    create(:poll_officer, user: user)
    create(:poll)
    login_as(user)
    visit root_path

    expect(page).to have_link("Polling officers")
    click_on "Polling officers"

    expect(current_path).to eq(officing_root_path)
    expect(page).to_not have_content "You do not have permission to access this page"
  end

  scenario 'Access as an administrator is authorized' do
    create(:administrator, user: user)
    create(:poll)
    login_as(user)
    visit root_path

    expect(page).to have_link("Polling officers")
    click_on "Polling officers"

    expect(current_path).to eq(officing_root_path)
    expect(page).to_not have_content "You do not have permission to access this page"
  end

  scenario "Poll officer access links" do
    create(:poll_officer, user: user)
    login_as(user)
    visit root_path

    expect(page).to have_link("Polling officers")
    expect(page).to_not have_link('Valuation')
    expect(page).to_not have_link('Administration')
    expect(page).to_not have_link('Moderation')
  end

  scenario 'Officing dashboard' do
    create(:poll_officer, user: user)
    create(:poll)
    login_as(user)
    visit root_path

    click_link 'Polling officers'

    expect(current_path).to eq(officing_root_path)
    expect(page).to have_css('#officing_menu')
    expect(page).to_not have_css('#valuation_menu')
    expect(page).to_not have_css('#admin_menu')
    expect(page).to_not have_css('#moderation_menu')
  end

  scenario 'Officing dashboard available for multiple sessions' do
    poll = create(:poll)
    booth = create(:poll_booth)
    booth_assignment = create(:poll_booth_assignment, poll: poll, booth: booth)

    user1 = create(:user)
    user2 = create(:user)
    officer1 = create(:poll_officer, user: user1)
    officer2 = create(:poll_officer, user: user2)

    create(:poll_shift, officer: officer1, booth: booth, date: Date.current, task: :vote_collection)
    create(:poll_shift, officer: officer2, booth: booth, date: Date.current, task: :vote_collection)

    officer_assignment_1 = create(:poll_officer_assignment, booth_assignment: booth_assignment, officer: officer1)
    officer_assignment_2 = create(:poll_officer_assignment, booth_assignment: booth_assignment, officer: officer2)

    in_browser(:one) do
      login_as user1
      visit officing_root_path
    end

    in_browser(:two) do
      login_as user2
      visit officing_root_path
    end

    in_browser(:one) do
      page.should have_content("Here you can validate user documents and store voting results")

      visit new_officing_residence_path
      within("#side_menu") do
        click_link "Validate document"
      end
      select 'DNI', from: 'residence_document_type'
      fill_in 'residence_document_number', with: "12345678Z"
      fill_in 'residence_year_of_birth', with: '1980'
      click_button 'Validate document'
      expect(page).to have_content 'Document verified with Census'
      click_button "Confirm vote"
      expect(page).to have_content "Vote introduced!"

      visit final_officing_polls_path
      page.should have_content("Polls ready for final recounting")
    end

    in_browser(:two) do
      page.should have_content("Here you can validate user documents and store voting results")

      visit new_officing_residence_path
      page.should have_content("Validate document")
      within("#side_menu") do
        click_link "Validate document"
      end
      select 'DNI', from: 'residence_document_type'
      fill_in 'residence_document_number', with: "12345678Y"
      fill_in 'residence_year_of_birth', with: '1980'
      click_button 'Validate document'
      expect(page).to have_content 'Document verified with Census'
      click_button "Confirm vote"
      expect(page).to have_content "Vote introduced!"

      visit final_officing_polls_path
      page.should have_content("Polls ready for final recounting")
    end
  end
end
