# encoding: utf-8
#

# Manages service hook calls from Github.
class Github::ServiceHookController < ApplicationController

  # Don't attempt to authenticate the user for these requests.
  skip_before_filter :authenticate_user!

  # POST /github/service_hook
  #
  # Endpoint where Github delivers its service hook requests.
  def create

    hook = GithubServiceHook.new(current_instance, params[:payload])
    hook.handle!

    render nothing: true

  end

end
