# encoding: utf-8
#

# Defines the instance where all content is scoped. Instances are loaded by the
# subdomain of incoming requests, allowing us to host many instances of Unify on
# the same code base.
#
# The instance contains basic information for the instance and the organization
# that owns it.
class Instance

  # Instances are Mongoid documents.
  include Mongoid::Document

  # Log created and updated-time.
  include Mongoid::Timestamps

  # Define the fields for the instance.
  field :subdomain, type: String
  
  # Embed a document containing information about the organization owning the
  # instance. Also, make the organization assignable through mass assignment.
  embeds_one :organization, class_name: 'InstanceOrganization'
  accepts_nested_attributes_for :organization
  attr_accessible :organization_attributes

  # Embed a collection of model sequences containing sequence details for each
  # data type for the instance.
  embeds_many(:model_sequences, as: :sequenceable) do
    def organization; for_model_class(Organization); end
    def person; for_model_class(Person); end
    def deal; for_model_class(Deal); end
    def project; for_model_class(Project); end
    def ledger_transaction; for_model_class(LedgerTransaction); end
    def invoice; for_model_class(Invoice); end

    def for_model_class(model_class)
      @target.select { |seq| seq.model_class == model_class.name }.first
    end
  end

  # Instances can have many comments.
  has_many :comments, dependent: :destroy

  # Instances can have many categories.
  has_many :categories, dependent: :destroy do

    # Return only event categories.
    def events
      where(:_type => EventCategory.name)
    end

    # Return only deal categories.
    def deals
      where(:_type => DealCategory.name)
    end

    # Return only project categories.
    def projects
      where(:_type => ProjectCategory.name)
    end
    
    # Return only ticket categories.
    def tickets
      where(:_type => TicketCategory.name)
    end
    
  end

  # Instances can have many events.
  has_many :events, dependent: :destroy

  # Instances can have many users.
  has_many :users, dependent: :destroy

  # Instances can have many contacts.
  has_many :contacts, dependent: :destroy do

    # Return only person-contacts.
    def people
      where(:_type => Person.name)
    end

    # Return only organization-contacts.
    def organizations
      where(:_type => Organization.name)
    end

  end

  # Instances can have many deals.
  has_many :deals, dependent: :destroy

  # Instances can have many deal stages.
  has_many :deal_stages, dependent: :destroy

  # Instances can have many sources.
  has_many :sources, dependent: :destroy

  # Instances can have many projects.
  has_many :projects, dependent: :destroy

  # Instances can have many milestones.
  has_many :milestones, dependent: :destroy

  # Instances can have many tickets.
  has_many :tickets, dependent: :destroy

  # Instances can have many pages.
  has_many :pages, dependent: :destroy

  # Instances can have many accounts.
  has_many :accounts, dependent: :destroy

  # Instances can have many tax codes.
  has_many :tax_codes, dependent: :destroy

  # Instances can have many payment forms.
  has_many :payment_forms, dependent: :destroy

  # Instances can have many ledger transactions.
  has_many :ledger_transactions, dependent: :destroy

  # Instances can have many invoices.
  has_many :invoices, dependent: :destroy

  # Instances can have many products.
  has_many :products, dependent: :destroy

  # Instances can embed many api applications.
  embeds_many :api_applications

  # Validate that the instance has a subdomain set, and that the subdomain is
  # unique for the whole application. Also, make the subdomain attribute
  # assignable through mass assignment.
  validates :subdomain, presence: true, uniqueness: { case_sensitive: false }
  attr_accessible :subdomain

  # When instantiating an instance, build the associated organization as well.
  after_initialize :build_embedded_organization

  # When instantiating an instance, build the associated model sequences as
  # well.
  after_initialize :build_model_sequences

  # Returns the instance for the specified subdomain.
  scope :for_subdomain, lambda { |subdomain| where(subdomain: subdomain) }

  private

  # Build the embedded organization object for the instance unless its already
  # set.
  def build_embedded_organization
    build_organization if organization.blank?
  end

  # Build the embedded model sequences for the instance.
  def build_model_sequences
    [Organization, Person, Deal, Project, LedgerTransaction, Invoice].each do |model_class|

      model_class_name = model_class.name
      if model_sequences.select { |ms| ms.model_class == model_class_name }.empty?

        sequence = ModelSequence.new
        sequence.model_class = model_class_name

        # Set the current value to 9999 for all but ledger transactions.
        sequence.current_value = 9999 unless model_class == LedgerTransaction

        model_sequences << sequence

      end

    end
  end

end
