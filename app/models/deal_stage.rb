# encoding: utf-8
#

# Deal stages define the categorization and likelyhood of a sale for a deal.
class DealStage

  # Deal stages are Mongoid documents.
  include Mongoid::Document

  # Define the fields for the deal.
  field :name, type: String
  field :percent, type: Integer
  field :color, type: String

  # Deal stages are associated with instances.
  belongs_to :instance

  # Deal stages are associated with deals.
  has_many :deals
  
  # Validate that the deal stage is associated with an instance.
  validates :instance, presence: true

  # Validate that the deal has a name set, and make the name attribute
  # assignable through mass assignment.
  validates :name, presence: true
  attr_accessible :name

  # Validate that the deal stage has a percent set, that its a number between 0
  # and 100, and that the percent value is unique for this instance. Also, make
  # the percent attribute assignable through mass assignment.
  validates :percent, presence: true, inclusion: { in: (0..100).to_a }, uniqueness: { scope: :instance_id }
  attr_accessible :percent

  # Validate that the deal stage has a color set, and make the color attribute
  # assignable through mass assignment.
  validates :color, presence: true
  attr_accessible :color

  # Sort deal stages by their name.
  scope :sorted_by_percentage, order_by(:percent.asc)

  # Returns true if this stage indicates that the deal has been won.
  #
  # @return [ TrueClass, FalseClass ] True if the stage indicates that the deal
  #   has been won, false otherwise.
  def won?
    percent.to_i == 100
  end

  # Returns true if this stage indicates that the deal has been lost.
  #
  # @return [ TrueClass, FalseClass ] True if the stage indicates that the deal
  #   has been lost, false otherwise.
  def lost?
    percent.to_i == 0
  end

  # Returns true if this stage indicates that the deal has been closed (won or
  # lost).
  #
  # @return [ TrueClass, FalseClass ] True if the stage indicates that the deal
  #   has been closed, false otherwise.
  def closed?
    won? || lost?
  end
  
end
