$(document).on 'ready page:load', ->
  PreviewMarkdown.init()
  ReplyEmbedded.init()
  $('[data-toggle="tooltip"]').tooltip()

  $('.at_textarea').atwho
    at: "@"
    data: "/users.json"
    tpl: "<li data-value='@${name}'>${name} <small>${email}</small></li>"

  $("#evaluate_details").qeditor({})
