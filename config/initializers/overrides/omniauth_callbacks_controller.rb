require 'devise_token_auth/omniauth_callbacks_controller'

module DeviseTokenAuth
  class OmniauthCallbacksController < DeviseTokenAuth::ApplicationController

    # Neo4j-compliant version
    def get_resource_from_auth_hash
      uid_resource = Neo4j::Session.current.query.match(n: {Person: {uid: auth_hash['uid'], provider: auth_hash['provider']}}).return(:n).first

      if uid_resource
        @resource = uid_resource.n
      else
        email_resource = Neo4j::Session.current.query.match(n: {Person: {email: auth_hash['info']['email']}}).return(:n).first
        if email_resource
          @resource = email_resource.n
          @resource.assign_attributes({uid: auth_hash['uid'], provider: auth_hash['provider']})
        else
          @resource = resource_class.new({uid: auth_hash['uid'], provider: auth_hash['provider']})
        end
        @oauth_registration = true
        set_random_password
      end

      @resource.assign_attributes(
          {
              email: auth_hash['info']['email'],
              firstname: auth_hash['info']['first_name'],
              lastname: auth_hash['info']['last_name'],
              telephone: auth_hash['info']['phone_number'],
              mobilephone: auth_hash['info']['gsm_number'],
              role: auth_hash['info']['profession']
          }
      )

      # assign any additional (whitelisted) attributes
      extra_params = whitelisted_params
      @resource.assign_attributes(extra_params) if extra_params

      @resource
    end

    # Fix for users created by the Apidae SSO login - deserialize doesnt work as expected
    def set_token_on_resource
      @resource.tokens = {} if @resource.tokens == '{}'
      @resource.tokens[@client_id] = {
          token: BCrypt::Password.create(@token),
          expiry: @expiry
      }
    end

    # Overridden to limit access in early test phases
    def create_auth_params
      @auth_params = {
          auth_token:     @token,
          client_id: @client_id,
          uid:       (@resource.active ? @resource.uid : nil),
          expiry:    @expiry,
          config:    @config
      }
      @auth_params.merge!(oauth_registration: true) if @oauth_registration
      @auth_params
    end

  end
end
