# encoding: utf-8
#

# Manages deal categories for the Unify instance.
class DealCategoriesController < CategoriesController

  expose(:category_type) { :deal }

end
