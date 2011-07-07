# encoding: utf-8
#

# Manages the ledger transactions attachments for a ledger transaction.
class LedgerTransactionAttachmentsController < ApplicationController

  expose(:transaction) { current_instance.ledger_transactions.find(params[:ledger_transaction_id]) }
  expose(:attachment) { transaction.attachments.find(params[:id]) }

  # GET /ledger_transactions/:ledger_transaction_id/attachments/:id
  #
  # Download an attachment from a ledger transaction.
  def show
    send_data(attachment.attachment.read, filename: attachment.filename, type: attachment.content_type)
  end

end
