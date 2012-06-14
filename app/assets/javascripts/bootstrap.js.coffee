$ ->
  $("a[rel=popover]").popover()
  $(".tooltip").tooltip()
  $("a[rel=tooltip]").tooltip()

# Transition out success alerts after 2 seconds
$ ->
  $(".alert-success").delay(2000).slideUp()