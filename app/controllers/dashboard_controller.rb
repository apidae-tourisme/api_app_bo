class DashboardController < ApplicationController
  before_filter :authenticate_admin!

  def index
  end

  def import_users
    oauth_config = Rails.application.config.omniauth_config
    client = OAuth2::Client.new(oauth_config[:client_id], oauth_config[:client_secret],
                                :site => oauth_config[:auth_site], :token_url => oauth_config[:token_path],
                                :token_method => :get)
    # token = client.client_credentials.get_token
    auth_url = client.auth_code.authorize_url(:redirect_uri => 'http://test-sso/callback/')
                   .gsub('api.apidae-tourisme.com', 'base.apidae-tourisme.com')

    # note : manque scope=sso
    # pour l'instant les exports nécessitent forcément un login type sso, avec redirection etc...
    # implémenter un login sso (avec strategie apidaebis) pour les admins afin de déclencher un export en callback
    # Q : pourquoi ne pas pouvoir utiliser un token comme les APIs en ecriture ?
    code = Faraday.get auth_url

    token = client.auth_code.get_token(code, :redirect_uri => 'http://test-sso/callback/')
    puts "token is : #{token.token}"

    # response = OAuth2::AccessToken.new(client, token.token)
    #                .get('http://api.apidae-tourisme.com/api/v002/sso/utilisateur/export-utilisateurs')
    # result = {}
    # if response && response.respond_to?(:parsed)
    #   result = response.parsed
    # end

    render nothing: true, status: :ok
    # utilisateur/export-utilisateurs
    # api.apidae-tourisme.com/api/v002/sso/utilisateur/export-utilisateurs
  end

  def import_projects

  end
end
