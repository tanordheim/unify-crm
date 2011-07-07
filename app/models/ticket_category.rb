# encoding: utf-8
#

# Ticket categories are subclasses of the Category class and are used to group
# tickets by the type of work that the ticket is about.
class TicketCategory < Category

  # Ticket categories can be associated with many tickets. If a category is
  # removed, the tickets associated with the category will have their category
  # association nullified.
  has_many :tickets, inverse_of: :category, dependent: :nullify

end
