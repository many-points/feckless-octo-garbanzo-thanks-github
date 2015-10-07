# content.coffee

get_url = (parent_object) ->
  return $(parent_object).find("input").val()

get_song_name = (parent_object) ->
  artist = $(parent_object).find(".title_wrap b a").text().trim()
  song = $(parent_object).find(".title_wrap .title a").text().trim()
  if song is ""
    song = $(parent_object).find(".title_wrap .title").text().trim()
  return "#{artist} \u2013 #{song}"

download_event = (event) ->
  event.preventDefault()
  parent = @.parentElement
  url = get_url parent
  pos = url.indexOf '?'
  if pos isnt -1
    url =  url.substr 0, pos
  name = "#{get_song_name parent}.mp3".replace '/', '-'
  console.log "#{url} #{name}"
  options = url: url, filename: name, conflictAction: 'uniquify'
  chrome.runtime.sendMessage options
  return false

add_event = (node) ->
  button = $(node).find(".area.clear_fix")[0]
  button.addEventListener "contextmenu", download_event, false

add_event_to_existing_nodes = ->
  nodes = [].slice.call $(".audio")
  nodes.forEach (node) -> add_event node

observer = new MutationObserver (mutations) ->
  mutations.forEach (mutation) ->
    nodes = [].slice.call mutation.addedNodes
    nodes.forEach (node) ->
      if node.id is "wrap2" or "search_table"
        audios = [].slice.call $(node).find ".audio"
        audios.forEach (audio) ->
          add_event audio
      if node.classList.contains "audio"
        add_event node

observer_config = childList: true, subtree: true

add_event_to_existing_nodes()

initial = $("body")[0]

if initial?
  observer.observe initial, observer_config
