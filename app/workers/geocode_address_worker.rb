# encoding: utf-8
#

# This is a Resque worker that performs geocode lookups on adresses embedded
# within a Mongoid document.
class GeocodeAddressWorker

  @queue = :geocode_addresses

  # Perform the geocode lookup of an address.
  #
  # @param [ Class ] document_class The class of the document containing the
  #   address to geocode.
  # @param [ BSON::ObjectId ] document_id The ID of the document containing the
  #   address to geocode.
  # @param [ BSON::ObjectId ] id The ID of the address embedded within the
  #   document to geocode.
  def self.perform(document_class, document_id, id)

    # Find the parent document and the address.
    document = document_class.constantize.find(document_id)
    address = document.addresses.find(id)

    # Perform a geocode lookup on the address.
    address.geocode

    # Map the coordinates to a time zone.
    address.set_time_zone_from_coordinates

    # Save the updated address.
    address.save!

  end

end
