setInterval(function(){
  if ($('html').attr('class') == 'shiny-busy') {
    $('#loading-content').show()
  } else {
    $('#loading-content').hide()
  }
}, 1000)
