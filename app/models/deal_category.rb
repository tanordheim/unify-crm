# encoding: utf-8
#

# Deal categories are subclasses of the Category class and are used to group
# deals by the type of delivery that the deal is about.
class DealCategory < Category

  # Deal categories can be associated with many deals. If a category is removed,
  # the deals associated with the category will have their category association
  # nullified.
  has_many :deals, inverse_of: :category, dependent: :nullify

end
