RSpec::Matchers.define :have_connected_account do |identity|
  match do
    within ".js-identities" do
      have_text(identity)
    end
  end
end
