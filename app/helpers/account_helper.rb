# encoding: utf-8
#

# Helpers for the Account model class.
module AccountHelper

  # Returns a collection of types for an account in a format ready to use in a
  # collection input element.
  def account_type_collection
    Account::TYPES.keys.sort.map do |type|
      [I18n.t("accounts.type.#{Account::TYPES[type]}"), type]
    end
  end

end
