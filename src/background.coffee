# background.coffee

chrome.extension.onMessage.addListener (request, sender, sendResponce) ->
    chrome.downloads.download request
    return true