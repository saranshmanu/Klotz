var count;
var myChart;
var $counter;
var $counters;
var isFirst = true;
var generateCounter = function() {
    return $counter.clone().slick({
        waitForAnimate: false,
        touchMove: false,
        infinite: true,
        vertical: true,
        arrows: false,
        swipe: false,
        speed: 10
    })
};

function debounce(b, d, a) {
    var c;
    return function() {
        var h = this,
            g = arguments;
        var f = function() {
            c = null;
            if (!a) {
                b.apply(h, g)
            }
        };
        var e = a && !c;
        clearTimeout(c);
        c = setTimeout(f, d);
        if (e) {
            b.apply(h, g)
        }
    }
}

function updateBlocks(c) {
    var e = BlockFromJSON(c.x);
    if ($("#bi-" + e.blockIndex).length > 0) {
        return
    }
    var b = "Unknown";
    if (e.foundBy != null) {
        b = '<a href="' + e.foundBy.link + '">' + e.foundBy.description + "</a>"
    }
    if (e.txIndex) {
        var a = e.txIndex.length
    } else {
        var a = 0
    }
    var d = formatMoney(e.totalBTCSent, true, 2);
    $('<tr id="bi-' + e.blockIndex + '"><td><div><a href="' + root + "block/" + e.hash + '">' + e.height + '</a></div></td><td data-time="' + e.time + '"><div>< 1 minute</div></td><td class="hidden-xs"><div>' + e.txIndex.length + '</div></td><td class="hidden-xs"><div>' + d + '</div></td><td class="hidden-xs"><div>' + b + "</div></td><td><div>" + (e.size / 1000).toFixed(2) + "</div></td></tr>").insertAfter($("#blocks tr:first")).find("div").hide().fadeIn("slow");
    $("#blocks tr:last-child").remove()
}

function updateTimes() {
    var a = new Date().getTime() / 1000;
    $("td[data-time]").each(function(b) {
        var e = parseInt($(this).data("time"));
        if (e == 0) {
            $(this).text("")
        }
        var d = a - e;
        if (d < 60) {
            $(this).text("< 1 minute")
        } else {
            if (d < 3600) {
                var c = (parseInt(d / 60) > 1) ? "s" : "";
                $(this).text(parseInt(d / 60) + " minute" + c)
            } else {
                var c = (parseInt(d / 3600) > 1) ? "s" : "";
                $(this).text(parseInt(d / 3600) + " hour" + c + " " + parseInt((d % 3600) / 60) + " minutes")
            }
        }
    })
}

function increaseTxCount() {

    var db = firebase.database();


    db.ref("live").on('value', function(snapshot){
        //console.log(snapshot);
        countOfDate=Object.keys(snapshot.val()).length;
        //console.log(countOfDate);
        count++;
        var k;
        
        var f = "000"+String(countOfDate);

        var g = f.length;
        var a = $(".counter").length;
        while (a < g) {
            var h = generateCounter();
            $counters.prepend(h);
            a++
        }
        for (var d = 0; d < g; d++) {
            var c = isFirst ? 0 : 200;
            var b = $($(".counter")[d]);
            var j = parseInt(f[d]);
            var e = b.slick("slickCurrentSlide");
            b.slick("slickSetOption", "speed", c);
            if (j === 0 && e === 9) {
                b.slick("slickGoTo", 10)
            } else {
                if (e === 0 && j === 1) {
                    b.slick("slickNext")
                } else {
                    b.slick("slickGoTo", j)
                }
            }
        }
        isFirst = false
    });


}

function createChart(e) {
    var g = [];
    var c = e.values;
    for (var b = 0; b < c.length; b++) {
        g.push(c[b]["y"])
    }
    var f = new Date();
    var a = f.getMonth();
    var h = f.setMonth(a - 4);
    myChart = Highcharts.chart("price-chart", {
        chart: {
            backgroundColor: "#000000"
        },
        title: {
            text: ""
        },
        credits: {
            enabled: false
        },
        tooltip: {
            enabled: false
        },
        xAxis: {
            type: "datetime",
            tickLength: 0,
            lineColor: "#afffc8",
            lineWidth: 0.5,
            tickInterval: 2629746000
        },
        yAxis: {
            title: "",
            gridLineColor: "transparent",
            opposite: true,
            lineColor: "#afffc8",
            lineWidth: 0.5
        },
        plotOptions: {
            series: {
                marker: {
                    enabled: false,
                    states: {
                        hover: {
                            enabled: false
                        }
                    }
                },
                pointStart: h,
                pointInterval: 86400000
            }
        },
        series: [{
            name: "Price",
            data: g,
            color: "#afffc8",
            showInLegend: false
        }]
    })
}

function setChartSize() {
    var c = $(window).width() - 40;
    var a = $(".container").first().width() - 40;
    var b = c <= 767 - 40 ? c : a / 2;
    myChart && myChart.setSize(b, 280, true)
}

function setExchangeRate(b) {
    var a = b.USD.last.toFixed(2);
    $(".exchange-rate").html(a)
}

function setMarketCap(b) {
    var a = parseInt(b.values[b.values.length - 1].y);
    $(".market-cap").html("$" + convert(a, 1))
}

function setHashRate(b) {
    var a = b.values[b.values.length - 1].y.toFixed(2);
    $(".hash-rate").html(convert(a, 1) + " TH/s")
}
webSocketConnect(function(a) {
    a.onmessage = debounce(function(c) {
        var b = $.parseJSON(c.data);
        if (b.op == "minitx") {
            increaseTxCount()
        } else {
            if (b.op == "block") {
                updateBlocks(b)
            }
        }
        setupSymbolToggle()
    }, 100);
    a.onopen = function() {
        a.send('{"op":"set_tx_mini"}{"op":"unconfirmed_sub"}{"op":"blocks_sub"}')
    }
});
$(document).ready(function() {
    $counters = $("#counters");
    $counter = $('<div class="counter width-20-mobile center bg-blue"><div>0</div><div>1</div><div>2</div><div>3</div><div>4</div><div>5</div><div>6</div><div>7</div><div>8</div><div>9</div></div>');
    var i = function() {
        return $(window).width() <= 1024
    };
    !i() && $(".search-bar").focus();
    setInterval(updateTimes, 1000);
    if (top.location != self.location) {
        top.location = self.location.href
    }
    $.get("https://blockchain.info/q/24hrtransactioncount?cors=true").done(function(k) {
        var j = generateCounter();
        count = parseInt(k);
        increaseTxCount();
        $counters.removeClass("invisible")
    });
    $.get("https://api.blockchain.info/charts/market-price?timespan=4months&format=json&cors=true&includeLastPoint=true").done(function(j) {
        createChart(j);
        $(window).trigger("resize")
    });
    $.get("https://blockchain.info/ticker?cors=true").done(setExchangeRate);
    $.get("https://api.blockchain.info/charts/market-cap?cors=true").done(setMarketCap);
    $.get("https://api.blockchain.info/charts/hash-rate?cors=true").done(setHashRate);
    var g = Math.round(new Date().getTime() / 1000);
    var d = g - (24 * 3600);
    var e = new Date(d * 1000).toDateString();
    var a = new Date().toLocaleTimeString();
    $("#yesterday").html(e + " " + a);
    $(window).on("resize", setChartSize);
    var f = $("#header-search");
    var b = $("#home-search");
    var h = $("#search_button");
    var c = function(j) {
        if (j.which === 13) {
            ga("send", "event", {
                eventCategory: "Search",
                eventAction: "Searching",
                eventLabel: j.data.origin
            })
        }
    };
    f.on("keypress", {
        origin: "Navbar Search"
    }, c);
    b.on("keypress", {
        origin: "Homepage Search"
    }, c);
    h.on("click", function(j) {
        ga("send", "event", {
            eventCategory: "Search",
            eventAction: "Searching",
            eventLabel: j.data.origin
        })
    })
});