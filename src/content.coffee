# content.coffee

vkdl =

  get_url: (parent) ->
    input = parent.querySelectorAll("input")[0]
    pos = input.value.indexOf '?'
    return input.value.substr 0, pos

  get_song_name: (parent) ->
    title_wrap = parent.querySelectorAll(".title_wrap")[0]
    name = title_wrap.innerText.trim().replace '/', '-'
    return "#{name}.mp3"
  
  download_file_event: (event) ->
    event.preventDefault()
    parent = @parentElement
    url = vkdl.get_url parent
    name = vkdl.get_song_name parent
    options = url: url, filename: name, conflictAction: 'uniquify'
    console.log "#{name} #{url}"
    #chrome.runtime.sendMessage options

  add_event: (node) ->
    button = node.querySelectorAll('.area.clear_fix')[0]
    button.addEventListener 'contextmenu', vkdl.download_file_event, false
    return

  add_event_to_existing_nodes: ->
    nodes = document.querySelectorAll '.audio'
    [].forEach.call nodes, (node) ->
      console.log node
      vkdl.add_event node
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