# encoding: utf-8
#

# Manages the people registered in the Unify instance.
class PeopleController < ContactsController

  expose(:people) { current_instance.contacts.people.sorted_by_name }
  expose(:person) do
    if params[:id].blank?
      p = Person.new(params[:person])
      p.instance = current_instance
      p
    else
      current_instance.contacts.people.find(params[:id])
    end
  end
  expose(:contact) { person }

  # GET /people/:id
  #
  # Shows information about a person.
  def show
    respond_with(person)
  end

  # GET /people/new
  #
  # Displays the form used to create a person.
  def new
    respond_with(person)
  end

  # POST /people
  #
  # Creates a new person.
  def create
    flash[:notice] = 'The person was successfully created.' if person.save
    respond_with(person)
  end

  # PUT /people/:id
  #
  # Update a person.
  def update
    flash[:notice] = 'The person was successfully updated.' if person.update_attributes(params[:person])
    respond_with(person)
  end

  # GET /people/typeahead
  #
  # Returns typeahead JSON data for people
  def typeahead

    results = people.csearch(params[:term] || '').map do |person|
      { value: person.id.to_s, label: person.name }
    end

    render json: results.to_json

  end

end
