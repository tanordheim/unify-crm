# encoding: utf-8
#

# Manages the overall contacts for the Unify instance. See the
# OrganizationsController and PeopleController for more specific sub class
# implementations.
class ContactsController < ApplicationController

  include FilteredResult::Controller

  respond_to :html, :js, :json

  expose(:contacts) { current_instance.contacts.sorted_by_name.filter_results(filters).page(params[:page]).per(10) }
  expose(:sources) { current_instance.sources.sorted_by_name }
  expose(:comments) { contact.all_comments.sorted_by_created_time.page(params[:comment_page]).per(10) }
  expose(:commentable) { contact }

  set_navigation_section :contacts

  # Set up the filters for the contact list.
  add_filter :state, type: :scope, scopes: [
    { label: 'All', key: :all, name: :active },
    { label: 'Deleted', key: :deleted, name: :deleted }
  ]
  add_filter :type, type: :scope, scopes: [
    { label: 'Contacts', key: :all, name: :scoped },
    { label: 'Organizations', key: :organizations, name: :organization_type },
    { label: 'People', key: :people, name: :person_type }
  ]
  add_filter :name, type: :search

  # GET /contacts
  #
  # Displays all contacts.
  def index
    respond_with(contacts)
  end

  # DELETE /<contact_type>/:id
  #
  # Flags a contact as deleted.
  def destroy
    contact.flag_as_deleted!
    render action: :update
  end

  # POST /<contact_type>/:id/restore
  #
  # Restores a contact from deleted-state.
  def restore
    contact.restore!
    render action: :update
  end

end
