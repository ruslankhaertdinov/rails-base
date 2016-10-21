shared_examples_for "success sign in" do
  scenario "User signs in" do
    visit new_user_session_path
    click_link "Sign in with Facebook"

    expect(page).to have_text(user.full_name)
    expect(current_path).to eq(root_path)
  end
end
