$.pushUrl = (title, url) ->
  history.pushState({}, title, url)
