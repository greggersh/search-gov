toggleMenu = ->
  $('body').toggleClass 'show-menu'
  $('#main-menu').toggleClass 'collapse'

menuShown = ->
  $('body').hasClass 'show-menu'

hideMenu = ->
  toggleMenu() if menuShown()

window.usasearch = {} unless window.usasearch?

window.usasearch.toggleMenu ?= toggleMenu

window.usasearch.hideMenu ?= hideMenu

$(document).on 'click.menuButton', '#menu-button', toggleMenu

focusMenuButton = ->
  if menuShown()
    toggleMenu()
    $('#menu-button').focus()

$(document).on 'focus.menuButton', '#menu-button', focusMenuButton

clickOnMenuWrapper = (e) ->
  e.stopPropagation()
  toggleMenu()

$(document).on 'click.menuWrapper', '.show-menu #main-menu-backdrop', clickOnMenuWrapper