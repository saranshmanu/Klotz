var assignDate = function (elementId, date) {
  var el = document.getElementById(elementId);
  el.textContent = date;
}

var d = new Date();
var day = d.getDate();
var startDate = d.setDate(day - 31);
var start = new Date(startDate);

assignDate('start-date', start.toLocaleDateString());
assignDate('current-date', new Date().toLocaleDateString());
