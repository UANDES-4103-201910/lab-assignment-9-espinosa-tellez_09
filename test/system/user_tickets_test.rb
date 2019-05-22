require "application_system_test_case"

class UserTicketsTest < ApplicationSystemTestCase
  setup do
    @user_ticket = user_tickets(:one)
  end

  test "visiting the index" do
    visit user_tickets_url
    assert_selector "h1", text: "User Tickets"
  end

  test "creating a User ticket" do
    visit user_tickets_url
    click_on "New User Ticket"

    click_on "Create User ticket"

    assert_text "User ticket was successfully created"
    click_on "Back"
  end

  test "updating a User ticket" do
    visit user_tickets_url
    click_on "Edit", match: :first

    click_on "Update User ticket"

    assert_text "User ticket was successfully updated"
    click_on "Back"
  end

  test "destroying a User ticket" do
    visit user_tickets_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "User ticket was successfully destroyed"
  end
end
