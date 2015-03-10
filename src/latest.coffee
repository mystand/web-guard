jQuery ->
  fireEvent = (element, event) ->
    `var evt`
    if document.createEvent
      # dispatch for firefox + others
      evt = document.createEvent('HTMLEvents')
      evt.initEvent event, true, true
      # event type,bubbling,cancelable
      !element.dispatchEvent(evt)
    else
      # dispatch for IE
      evt = document.createEventObject()
      element.fireEvent 'on' + event, evt

  latestNumber = 1
  elems = window.jq ".d-A"
  fireEvent(elems[latestNumber], "mousedown")
  fireEvent(elems[latestNumber], "mouseup")