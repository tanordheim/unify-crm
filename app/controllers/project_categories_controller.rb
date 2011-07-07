# encoding: utf-8
#

# Manages project categories for the Unify instance.
class ProjectCategoriesController < CategoriesController

  expose(:category_type) { :project }

end
