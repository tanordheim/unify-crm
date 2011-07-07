# encoding: utf-8
#

# Deals are sales-deals that lead up to a lost deal or a won project. They
# define the process of aquiring a project with a client.
class Deal

  PRICE_TYPES = {
    '0' => :fixed,
    '1' => :per_hour,
    '2' => :per_month,
    '3' => :per_year
  }

  # Deals are Mongoid documents.
  include Mongoid::Document

  # Log created and updated-time.
  include Mongoid::Timestamps

  # Add comment support to deals.
  include Mongoid::Comments
  
  # Enable model sequence support for deals.
  include Mongoid::ModelSequenceSupport
  
  # Add filtering support to deals.
  include FilteredResult::Model
  
  # Define the fields for the deal.
  field :name, type: String
  field :description, type: String
  field :price, type: Float, default: 0.0
  field :price_type, type: Integer
  field :duration, type: Integer
  field :probability, type: Integer, default: 50
  field :expecting_close_on, type: Date
  field :closed_on, type: Date

  # Deals are associated with instances.
  belongs_to :instance

  # Deals are associated with organizations.
  belongs_to :organization

  # Deals are associated with people.
  belongs_to :person

  # Deals are associated with stages.
  belongs_to :stage, class_name: 'DealStage'

  # Deals can be associated with a category that describes what kind of delivery
  # the deal is about.  Also, make the category attributes assignable through
  # mass assignment.
  belongs_to :category, class_name: 'DealCategory'
  attr_accessible :category, :category_id

  # Deals can be associated with sources.
  belongs_to :source

  # Deals are associated with an user that acts as the user responsible for the
  # deal.
  belongs_to :user
  
  # Validate that the deal is associated with an instance.
  validates :instance, presence: true
  
  # Validate that the deal is associated with an organization, and make the
  # organization and organization_id attributes assignable through mass
  # assignment.
  validates :organization, presence: true
  attr_accessible :organization, :organization_id
  
  # Make the person attributes assignable through mass assignment.
  attr_accessible :person, :person_id

  # Validate that the deal is associated with a stage, and make the stage and
  # stage_id attributes assignable through mass assignment.
  validates :stage, presence: true
  attr_accessible :stage, :stage_id

  # Validate that the deal is associated with a user, and make the user and
  # user_id attributes assignable through mass assignment.
  validates :user, presence: true
  attr_accessible :user, :user_id

  # Validate that the deal has a name set, and make the name attribute
  # assignable through mass assignment.
  validates :name, presence: true
  attr_accessible :name
  
  # Make the price attributes assignable through mass assignment.
  attr_accessible :price

  # Validate that the price type contains a valid value if set. Also, make the
  # price_type attribute assignable through mass assignment.
  validates :price_type, inclusion: { in: PRICE_TYPES.keys.map(&:to_i), allow_blank: true }
  attr_accessible :price_type

  # Make the description attribute assignable through mass assignment.
  attr_accessible :description
  
  # Make the duration attribute assignable through mass assignment.
  attr_accessible :duration
  
  # Validate that the deal has a probability set, and that it contains a valid
  # value. Also, make the probability attribute assignable through mass
  # assignment.
  validates :probability, presence: true, inclusion: { in: (0..100).to_a }
  attr_accessible :probability

  # Make the source attributes assignable through mass assignment.
  attr_accessible :source, :source_id
  
  # Make the expecting_close_on attribute assignable through mass assignment.
  attr_accessible :expecting_close_on

  # Sort deals by their creation time.
  scope :sorted_by_created_time, order_by(:created_at.desc)

  # Nullify the duration if a deal is saved with a fixed price.
  before_save :nullify_duration_if_fixed_price

  # Override the probability if the stage indicates that the deal has been won
  # or lost.
  before_save :override_probability_if_won_or_lost

  # Set the closed_on attribute depending on the deal stage.
  before_save :set_closed_on_from_deal_stage

  # Set the default stage on the deal if no stage is set.
  before_validation :set_default_stage
  
  # Returns the name of the price type associated with this deal.
  #
  # @return [ Symbol ] A name identifying the price type code for this deal.
  def price_type_name
    PRICE_TYPES[price_type.to_s]
  end

  # Returns the total value of the deal based on the price and duration.
  #
  # @return [ Float ] The total value of the deal.
  def total_value
    duration.blank? || duration == 0 ? price : (price * duration)
  end

  private

  # Nullify the duration of the deal if a deal is attempted saved with both a
  # fixed price and a duration set.
  def nullify_duration_if_fixed_price
    self.duration = nil if price_type_name == :fixed
  end

  # Override the probability value if the stage indicates that the deal has been
  # won or lost.
  def override_probability_if_won_or_lost
    unless self.stage.blank?
      self.probability = 100 if self.stage.won?
      self.probability = 0 if self.stage.lost?
    end
  end

  # Set the closed_on attribute based on the deal stage.
  def set_closed_on_from_deal_stage
    if self.stage.blank?
      self.closed_on = nil
    else
      self.closed_on = Date.today if (self.stage.won? || self.stage.lost?) && self.closed_on.blank?
      self.closed_on = nil unless self.stage.won? || self.stage.lost?
    end
  end

  # Set the default stage of the deal if no stage is present.
  def set_default_stage
    if self.stage.blank?
      self.stage = self.instance.deal_stages.where(:percent.gt => 0).sorted_by_percentage.first
    end
  end
  
end
