# content.coffee

Array.prototype.first = -> @[0]
NodeList.prototype.first = -> @[0]
NodeList.prototype.forEach = Array.prototype.forEach

Element.prototype._addEventListener = Element.prototype.addEventListener
Element.prototype.addEventListener = (event, listener, useCapture) ->
  @_addEventListener(event, listener, useCapture)
  if not @listenerList then @listenerList = {}
  if not @listenerList[event] then @listenerList[event] = []
  @listenerList[event].push listener

vkdl =

  get_url: (parent) ->
    parent
    .querySelector "input"
    .value
    .split '?'
    .first null

  get_song_name: (parent) ->
    parent
    .querySelector ".title_wrap"
    .innerText
    .trim null
    .replace '/', '-'
    .concat '.mp3'
  
  download_file_event: () ->
    return (event) ->
      event.preventDefault()
      url  = vkdl.get_url @parentElement
      name = vkdl.get_song_name @parentElement
      console.log "vkdl: #{name}\n#{url}"
      options = url: url, filename: name, conflictAction: 'uniquify'
      #chrome.runtime.sendMessage options

  add_event: (node) ->
    button = node.querySelector '.area.clear_fix'
    if button.listenerList?.contextmenu? then return
    button.addEventListener 'contextmenu', vkdl.download_file_event null
    return

  add_event_to_existing_nodes: ->
    nodes = document.querySelectorAll '.audio'
    nodes.forEach (node) ->
      vkdl.add_event node
    return

  observer: new MutationObserver (mutations) ->
    mutations.forEach (mutation) ->
      mutation.addedNodes.forEach (node) ->
        if node.classList?.contains 'audio'
          vkdl.add_event node
        else
          search = node.querySelectorAll? '.audio'
          search?.forEach (node) ->
            vkdl.add_event node

  start_observer: ->
    config = childList: true, subtree: true
    page_body = document.querySelector '#page_body'
    box_layer = document.querySelector '#box_layer'
    if page_body? then vkdl.observer.observe page_body, config
    if box_layer? then vkdl.observer.observe box_layer, config

vkdl.add_event_to_existing_nodes null
vkdl.start_observer null