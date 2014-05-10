(function() {
  var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

  define(['world/map'], function(Map) {
    var Render;
    return Render = (function() {
      function Render() {
        this.paint = __bind(this.paint, this);
        this.map = Map;
        this.paint();
      }

      Render.prototype.paint = function() {
        var col, row, x, y, _i, _len, _ref, _results;
        _ref = this.map;
        _results = [];
        for (x = _i = 0, _len = _ref.length; _i < _len; x = ++_i) {
          row = _ref[x];
          _results.push((function() {
            var _j, _len1, _results1;
            _results1 = [];
            for (y = _j = 0, _len1 = row.length; _j < _len1; y = ++_j) {
              col = row[y];
              _results1.push(this.getPoint(x, y).addClass(col));
            }
            return _results1;
          }).call(this));
        }
        return _results;
      };

      Render.prototype.getPoint = function(x, y) {
        return $('.map-lost-woods .map-row-' + x + ' .map-col-' + y);
      };

      return Render;

    })();
  });

}).call(this);
