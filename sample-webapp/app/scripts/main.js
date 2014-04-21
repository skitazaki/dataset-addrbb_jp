/*global d3*/
'use strict';

var DATADIR = 'data',
    SWITCH_INTERVAL = 5000;

var width = 800, height = 450;

var map = d3.select('#main')
            .append('svg')
            .attr('width', width)
            .attr('height', height)
            .append('g');

var updateMap = function(addrCode, addrName) {
    var fname = DATADIR + '/boundary/' + addrCode.substr(0, 2) + '/' + addrCode + '.geojson';
    d3.json(fname, function(err, feature) {
        if (err) {
            return;
        }

        // [Center a map in d3 given a geoJSON object]
        // (http://stackoverflow.com/questions/14492284/center-a-map-in-d3-given-a-geojson-object)
        var projection = d3.geo.mercator()
                           .scale(1)
                           .translate([0, 0]);
        var path = d3.geo.path()
                     .projection(projection);
        var b = path.bounds(feature),
            s = 0.95 / Math.max((b[1][0] - b[0][0]) / width, (b[1][1] - b[0][1]) / height),
            t = [(width - s * (b[1][0] + b[0][0])) / 2, (height - s * (b[1][1] + b[0][1])) / 2];

        // Update scale and transform rule using bounding-box calculation.
        projection
            .scale(s)
            .translate(t);

        map.select('path').remove();

        map.append('path')
           .datum(feature)
           .attr('d', path)
           .attr('fill', 'green')
           .attr('stroke', '#222');
        d3.select('#addr-name').text(addrCode + ': ' + addrName);
    });
};

d3.tsv(DATADIR + '/addrcode.txt', function(err, addrs) {
    setTimeout(function() {
        var i = Math.floor(Math.random() * addrs.length),
            addr = addrs[i];
        updateMap(addr.code, addr.name);
        d3.select('.progress').classed('hide', true);
    }, SWITCH_INTERVAL / 2);
    setInterval(function() {
        var i = Math.floor(Math.random() * addrs.length),
            addr = addrs[i];
        updateMap(addr.code, addr.name);
    }, SWITCH_INTERVAL);
});

