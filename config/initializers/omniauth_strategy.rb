# require 'omniauth-oauth2'
# require 'json'
#
# module OmniAuth
#   module Strategies
#     class Apidae < OmniAuth::Strategies::OAuth2
#
#       option :name, 'apidae'
#       option :provider_ignores_state, true
#       option :client_options, {:site => Rails.application.config.omniauth_config[:authorize_site]}
#       option :authorize_params, {:scope => 'sso'}
#       option :token_params, {:headers => {'Accept' => 'application/json',
#                                           'Authorization' => "Basic #{Base64.encode64(Rails.application.config.omniauth_config[:client_id] + ':' + Rails.application.config.omniauth_config[:client_secret]).gsub("\n", '')}"}}
#
#       uid { profile_hash[:id].to_s }
#
#       info do
#         {
#             :email => profile_hash[:email],
#             :first_name => profile_hash[:firstName],
#             :last_name => profile_hash[:lastName],
#             :phone_number => profile_hash[:phoneNumber],
#             :gsm_number => profile_hash[:gsmNumber],
#             :profession => profile_hash[:profession]
#         }
#       end
#
#       def profile_hash
#         if @profile_hash.nil?
#           response = access_token.get(Rails.application.config.omniauth_config[:profile_url])
#           if response.status == 200
#             @profile_hash = JSON.parse response.body, :symbolize_names => true
#           end
#         end
#         @profile_hash
#       end
#
#     end
#   end
# end
