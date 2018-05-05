// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, or any plugin's
// vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require rails-ujs
//= require turbolinks
//= require jquery3
//= require jquery_ujs
//= require popper
//= require bootstrap-sprockets
//= require_tree .

$('document').ready(function() {

    setTimeout(function() {
    $('.alert-success').fadeOut('fast');
    }, 2000);
    setTimeout(function() {
    $('.alert-info').fadeOut('fast');
    }, 2000);
    setTimeout(function() {
        $('#if_button').click(function() {
            var winref = window.open('http://139.59.187.53/sidekiq', 'sideKiqTerminal', '', true)
            if(winref.location.href === 'about:blank') {
                winref.location.href = 'http://139.59.187.53/sidekiq';
            }
      });
    }, 2000);

});
