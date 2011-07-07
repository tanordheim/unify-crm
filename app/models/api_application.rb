# encoding: utf-8
#

# API applications defines external applications that are allowed to perform
# tasks in Unify via the REST API.
class ApiApplication

  # API applications are Mongoid documents.
  include Mongoid::Document

  # Define the fields for the API application.
  field :token, type: String
  field :key, type: String
  field :name, type: String
  field :sso_enabled, type: Boolean, default: false
  field :sso_callback_url, type: String

  # API applications are embedded within instances.
  embedded_in :instance

  # Validate that the API application has a token, and that the token is unique.
  validates :token, presence: true, uniqueness: true

  # Validate that the API application has a key, and that the key is unique.
  # Also, make the key attribute assignable through mass assignment.
  validates :key, presence: true, uniqueness: true
  attr_accessible :key

  # Validate that the API application has a name, and make the name attribute
  # assignable through mass assignment.
  validates :name, presence: true
  attr_accessible :name

  # Validate that the API application has a SSO callback URL if SSO is enabled.
  # Also, make the sso_callback_url and sso_enabled attributes assignable
  # through mass assignment.
  validates :sso_callback_url, presence: { if: :sso_enabled? }
  attr_accessible :sso_callback_url, :sso_enabled

  # When instantiating an application, build the secret token.
  after_initialize :generate_token

  # Returns only API applications with SSO enabled.
  scope :sso_enabled, where(sso_enabled: true)
  
  # Checks if single sign-on is enabled for this application.
  #
  # @return [ TrueClass, FalseClass ] True if SSO is enabled, false otherwise.
  def sso_enabled?
    sso_enabled
  end

  # Returns an encrypted SSO callback URL for the specified user.
  #
  # @param [ User ] user The user that logged in via the SSO authentication
  #   process.
  #
  # @return [ String ] The callback URL to send the user to after autenticating.
  def sso_callback_url_for(user)

    sso_token = encrypt_sso_token_for_user(user)

    url = sso_callback_url.dup
    if sso_callback_url =~ /\?/
      url << '&'
    else
      url << '?'
    end
    url << "sso_token=#{sso_token}"

    url

  end

  # Encrypts a SSO token for the specified user.
  #
  # @parm [ User ] user The user to encrypt a SSO token for.
  #
  # @return [ String ] The encrypted SSO token.
  def encrypt_sso_token_for_user(user)
    sso_token = Encryptor.encrypt(user.id.to_s, key: token)
    Base64.urlsafe_encode64(sso_token)
  end

  private

  # Generate the token for this API application.
  def generate_token
    self.token ||= SecureRandom.hex(16)
  end
  
end
