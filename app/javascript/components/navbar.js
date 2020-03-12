$('.navbar-brand').on('click', function(e){
  // e.preventDefault();
  $(this).addClass('on');
  $(this).one('animationend', function(event) {
    $(this).removeClass('on')
  });
});

$('#navbar-header').on('click', function(e){
  // e.preventDefault();
  $(this).addClass('header-clicked');
  $(this).one('animationend', function(event) {
    $(this).removeClass('header-clicked')
  });
});
