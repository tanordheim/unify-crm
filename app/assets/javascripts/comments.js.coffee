$ ->

  $('[data-toggle="scm-comment-files"]').live 'click', (e) ->
    e.preventDefault()

    link = $(e.target)
    container = link.closest('td.comment')

    $('.scm-comment-files', container).slideDown('fast')
