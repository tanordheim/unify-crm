# encoding: utf-8
#

# Manages ticket categories for the Unify instance.
class TicketCategoriesController < CategoriesController

  expose(:category_type) { :ticket }

end
