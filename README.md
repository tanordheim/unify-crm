# Unify CRM

This is an open sourced version of a CRM-like tool I built and provided access to when working as a self-employed consultant around 2011/2012. It has features like:

- Multitenancy, where all data is scoped to an "instance" of the system based on the subdomain being used. Each instance contains setting allowing the owner to adjust the instance to their liking and needs.
- Registering and managing companies/customers and contacts/employees to keep track of who the business is interacting with.
- Basic accounting features like invoicing and payment tracking.
- Basic calendar support and ability to share calendars between users.
- Tracking deals and following them up across their lifetime until closed.
- Threaded discussions that can be used by users of the system, available on most types of content and allows internal discussions to happen inside the app for visibility.
- Basic project management support with projects, milestones, tickets and progress tracking, associated with companies/customers. Also supports receiving webhooks from GitHub to automatically add comments to relevant tickets via commit messages, getting the comment message and list of changed files embedded in the UI.

It's implemented using Ruby on Rails 3, with MongoDB as underlying storage. As a product, it is fairly feature complete and was successfully in production for a while.
The code has however not been touched for nearly 10 years, and should be viewed through that lens as well.

## Running the project locally

The project can be started locally by running `docker-compose up`. The system should be available at http://test.127.0.0.1.nip.io:3000/ with the default login `test` / `secret`.

Be advised that this is running some rather old software, with old dependencies, that likely have issues. Several tests are disabled to get the project running after 10+ years of rot.
