# content.coffee

Array.prototype.first = -> @[0]
NodeList.prototype.first = -> @[0]
NodeList.prototype.forEach = Array.prototype.forEach

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
    that = this
    return (event) ->
      event.preventDefault()
      url  = that.get_url @parentElement
      name = that.get_song_name @parentElement
      console.log "#{name} #{url}"
      options = url: url, filename: name, conflictAction: 'uniquify'
      #chrome.runtime.sendMessage options

  add_event: (node) ->
    button = node.querySelector '.area.clear_fix'
    button.addEventListener 'contextmenu', @download_file_event null
    return

  add_event_to_existing_nodes: ->
    that = this
    nodes = document.querySelectorAll '.audio'
    nodes.forEach (node) ->
      that.add_event node
    return

  observer: new MutationObserver (mutations) ->
    mutations.forEach (mutation) ->
      return
    return

  start_observer: ->
    config = childList: true, subtree: true
    initial = null
    if initial? then @observer.observe initial, config

vkdl.add_event_to_existing_nodes()
#vkdl.start_observer()