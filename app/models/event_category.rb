# encoding: utf-8
#

# Event categories are subclasses of the Category class and allow events to be
# grouped by the type of event.
class EventCategory < Category

  # Event categories can be associated with many events. If a category is
  # removed, the events associated with the category will have their category
  # association nullified.
  has_many :events, inverse_of: :category, dependent: :nullify

end
