# content.coffee

Array.prototype.first = -> @[0]

Element.prototype._addEventListener = Element.prototype.addEventListener
Element.prototype.addEventListener = (event, listener, useCapture) ->
  @_addEventListener(event, listener, useCapture)
  if not @listenerList then @listenerList = {}
  if not @listenerList[event] then @listenerList[event] = []
  @listenerList[event].push listener

processArray = (items, process) ->
  if items.length is 0 then return
  index = 0
  setTimeout () ->
    item = items[index]
    process item
    index += 1
    if index < items.length
      setTimeout arguments.callee, 25
  , 25

vkdl =

  get_url: (parent) ->
    parent
    .querySelector "input"
    .value
    .split '?'
    .first()

  get_artist_name: (parent) ->
    parent
    .querySelector ".title_wrap b"
    .innerText
    .trim()

  get_track_name: (parent) ->
    parent
    .querySelector ".title_wrap .title"
    .innerText
    .trim()

  get_file_name: (parent) ->
    artist = @get_artist_name parent
    track  = @get_track_name  parent
    "#{artist} \u2013 #{track}.mp3"
    .replace '/', '-'
  
  download_file_event: (event) ->
    event.preventDefault()
    url  = vkdl.get_url @parentElement
    name = vkdl.get_file_name @parentElement
    options = url: url, filename: name, conflictAction: 'uniquify'
    chrome.runtime.sendMessage options

  add_event: (node) ->
    button = node.querySelector '.area.clear_fix'
    if button.listenerList?.contextmenu? then return
    button.addEventListener 'contextmenu', vkdl.download_file_event
    return

  add_event_to_existing_nodes: ->
    nodes = document.querySelectorAll '.audio'
    processArray nodes, vkdl.add_event
    return

  observer: new MutationObserver (mutations) ->
    processArray mutations, (mutation) ->
      processArray mutation.addedNodes, (node) ->
        if node.classList?.contains 'audio'
          vkdl.add_event node
        else
          nodes = node.querySelectorAll? '.audio'
          if nodes? and nodes.length isnt 0
            processArray nodes, vkdl.add_event

  start_observer: ->
    config = childList: true, subtree: true
    page_body = document.querySelector '#page_body'
    box_layer = document.querySelector '#box_layer'
    if page_body? then vkdl.observer.observe page_body, config
    if box_layer? then vkdl.observer.observe box_layer, config

vkdl.add_event_to_existing_nodes()
vkdl.start_observer()