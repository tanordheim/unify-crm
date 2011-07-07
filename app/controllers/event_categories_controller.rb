# encoding: utf-8
#

# Manages event categories for the Unify instance.
class EventCategoriesController < CategoriesController

  expose(:category_type) { :event }

end
