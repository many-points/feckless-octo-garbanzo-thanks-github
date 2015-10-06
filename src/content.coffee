# content.coffee

get_url = (parent_object) ->
  return $(parent_object).find("input").val()

get_song_name = (parent_object) ->
  artist = $(parent_object).find(".title_wrap b a").text().trim()
  song = $(parent_object).find(".title_wrap .title a").text().trim()
  if song is ""
    song = $(parent_object).find(".title_wrap .title").text().trim()
  return "#{artist} – #{song}"

initial_list = $("#initial_list")[0]

download_event = (event) ->
  event.preventDefault()
  parent = @.parentElement

  url = get_url parent
  name = get_song_name parent

  console.log "#{url} #{name}"

  return false

observer = new MutationObserver (mutations) ->
  mutations.forEach (mutation) ->
    adds = mutation.addedNodes[0]
    if $(adds).hasClass("audio")
      button = $(adds).find(".area.clear_fix")[0]
      button.addEventListener "contextmenu", download_event, false


config = childList: true

observer.observe initial_list, config