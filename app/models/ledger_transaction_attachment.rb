# encoding: utf-8
#

# Ledger transaction attachments defines an attachment on a ledger transaction
# containing documentation for the transaction.
class LedgerTransactionAttachment

  # Ledger transaction attachments are Mongoid documents.
  include Mongoid::Document

  # Enable model sequence support for ledger transaction attachments.
  include Mongoid::ModelSequenceSupport
  
  # Mount a CarrierWave uploader on the attachment and make the file attribute
  # assignable through mass assignment.
  mount_uploader :attachment, LedgerTransactionAttachmentUploader
  attr_accessible :attachment

  # Define the fields for the ledger transaction attachment.
  field :filename, type: String
  field :content_type, type: String
  field :size, type: Integer

  # Ledger transaction attachments are embedded in ledger transactions.
  embedded_in :ledger_transaction, inverse_of: :attachments

  # Validate that an attachment is uploaded when the attachment is created.
  validates :attachment, presence: { if: :require_attachment? }

  # Validate that the attachment has a content type defined.
  validates :content_type, presence: true
  
  # Validate that the attachment has a filename defined.
  validates :filename, presence: true
  
  # Validate that the attachment has a size defined.
  validates :size, presence: true
  
  # Assign the content type and file size when saving an attachment.
  before_validation :update_content_type_and_size

  private

  # Update the content_type and size attributes of the attachment if the
  # attachment-file associated with the attachment has been modified when the
  # model is persisted.
  def update_content_type_and_size
    if attachment.present? && (attachment_changed? || new_record?)
      self.filename = attachment.filename unless attachment.filename.blank?
      self.content_type = attachment.file.content_type unless attachment.file.content_type.blank?
      self.size = attachment.file.size unless attachment.file.size.blank?
    end    
  end

  # Returns the parent model holding the identifier sequences to use when
  # generating the sequence for this class.
  #
  # @return [ LedgerTransaction ] The instance of the parent model holding
  #   identifier sequences used to generating the sequence for this class.
  def identifier_parent
    ledger_transaction
  end

  # Checks if a attachment-file is required for this attachment. This is true
  # when an attachment without a file already associated with it is about to be
  # persisted.
  #
  # @return [ TrueClass, FalseClass ] True if a file association is required,
  #   false otherwise.
  def require_attachment?
    new_record?
  end

end
