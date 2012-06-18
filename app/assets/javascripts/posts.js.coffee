wrapText = (elementID, openTag, closeTag) ->
  textArea = $("##{elementID}") #select the text area
  len = textArea.val().length #total length of the text area
  start = textArea[0].selectionStart # start of the selected text
  end = textArea[0].selectionEnd # end of the selected text
  selectedText = textArea.val().substring(start, end) # The selected Text
  replacement = openTag + selectedText + closeTag # string with the selected text wrapped in the bbcode
  textArea.val(textArea.val().substring(0,start) + replacement + textArea.val().substring(end, len)) # perform the replacement
  
insertTextBeforeSelection = (elementID, tag) ->
  textArea = $("##{elementID}") #select the text area
  len = textArea.val().length #total length of the text area
  start = textArea[0].selectionStart # start of the selected text
  end = textArea[0].selectionEnd # end of the selected text
  selectedText = textArea.val().substring(start, end) # The selected Text
  replacement = "#{tag} #{selectedText}" # string with the selected text wrapped in the bbcode
  textArea.val(textArea.val().substring(0,start) + replacement + textArea.val().substring(end, len)) # perform the replacement

insertWrappedText = (elementID, text, openTag, closeTag) ->
  textArea = $("##{elementID}") #select the text area
  len = textArea.val().length #total length of the text area
  start = textArea[0].selectionStart # start of the selected text
  end = textArea[0].selectionEnd # end of the selected text
  selectedText = textArea.val().substring(start, end) # The selected Text
  replacement = openTag + text + closeTag # string with the selected text wrapped in the bbcode
  textArea.val(textArea.val().substring(0,start) + replacement + textArea.val().substring(end, len)) # perform the replacement

$('#bold_button').click (event) ->
  event.preventDefault()
  wrapText('post_body', '[b]', '[/b]')
 
$('#italics_button').click (event) ->
  event.preventDefault()
  wrapText('post_body', '[i]', '[/i]')
  
$('#underline_button').click (event) ->
  event.preventDefault()
  wrapText('post_body', '[u]', '[/u]')
  
$('#quote_button').click (event) ->
  event.preventDefault()
  wrapText('post_body', '[quote]', '[/quote]')
  
$('#code_button').click (event) ->
  event.preventDefault()
  wrapText('post_body', '[code]', '[/code]')
  
$('#list_button').click (event) ->
  event.preventDefault()
  wrapText('post_body', '[list]', '[/list]')
  
$('#list_item_button').click (event) ->
  event.preventDefault()
  insertTextBeforeSelection('post_body', '[*]')
  
$('#img_button').click (event) ->
  event.preventDefault()
  wrapText('post_body', '[img]', '[/img]')
  
$('#bigimg_button').click (event) ->
  event.preventDefault()
  wrapText('post_body', '[bigimg]', '[/bigimg]')
  
$('#url_button').click (event) ->
  event.preventDefault()
  name = prompt("Please enter a URL", "http://")
  insertWrappedText('post_body', name, '[url]', '[/url]') if name?
  
$('#spoiler_button').click (event) ->
  event.preventDefault()
  wrapText('post_body', '[spoiler]', '[/spoiler]')