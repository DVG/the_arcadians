wrapText = (elementID, openTag, closeTag) ->
  textArea = $("##{elementID}") #select the text area
  len = textArea.val().length #total length of the text area
  start = textArea[0].selectionStart # start of the selected text
  end = textArea[0].selectionEnd # end of the selected text
  selectedText = textArea.val().substring(start, end) # The selected Text
  replacement = openTag + selectedText + closeTag # string with the selected text wrapped in the bbcode
  textArea.val(textArea.val().substring(0,start) + replacement + textArea.val().substring(end, len)) # perform the replacement
  
$('#bold_button').click (event) ->
 wrapText('post_body', '[b]', '[/b]')
 event.preventDefault()
 
$('#italics_button').click (event) ->
  wrapText('post_body', '[i]', '[/i]')
  event.preventDefault()