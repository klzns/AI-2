(function() {
  define(['world/map'], function(Map) {
    var Grid;
    return Grid = (function() {
      function Grid() {
        this.map = Map;
        this.grid = [];
        this.generate();
      }

      Grid.prototype.generate = function() {};

      return Grid;

    })();
  });

}).call(this);
