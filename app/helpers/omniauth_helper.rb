module OmniauthHelper
  def provider_name(provider)
    t "active_record.attributes.identity.provider_name.#{provider}"
  end
end
