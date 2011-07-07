# encoding: utf-8
#

# Project categories are subclasses of the Category class and are used to group
# projects by the type of delivery that the project is about.
class ProjectCategory < Category

  # Project categories can be associated with many project. If a category is
  # removed, the projects associated with the category will have their category
  # association nullified.
  has_many :projects, inverse_of: :category, dependent: :nullify

end
