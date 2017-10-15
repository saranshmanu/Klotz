$(document).ready(function () {
  var test = document.getElementById('full-navbar');
  if (test) {
    var home = document.getElementById('navbar-home');
    var wallet = document.getElementById('navbar-wallet');
    var charts = document.getElementById('navbar-charts');
    var stats = document.getElementById('navbar-stats');
    var markets = document.getElementById('navbar-markets');
    var api = document.getElementById('navbar-api');

    var GA = function (label) {
      ga('send', 'event', {
        'eventCategory': 'Click',
        'eventAction': 'Header Click',
        'eventLabel': label
      });
    };

    home.addEventListener('click', function () { GA('navbar-home'); });
    wallet.addEventListener('click', function () { GA('navbar-wallet'); });
    charts.addEventListener('click', function () { GA('navbar-charts'); });
    stats.addEventListener('click', function () { GA('navbar-stats'); });
    markets.addEventListener('click', function () { GA('navbar-markets'); });
    api.addEventListener('click', function () { GA('navbar-api'); });
  }
});
