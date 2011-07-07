# encoding: utf-8
#

class LedgerTransactionAttachmentUploader < CarrierWave::Uploader::Base

  # Override the directory where uploaded files will be stored.
  def store_dir
    "ledger-transaction-attachments/#{model.id}"
  end

end
