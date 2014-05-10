(function() {
  define(function() {
    var Node;
    return Node = (function() {
      function Node(x, y, terrain) {
        this.x = x;
        this.y = y;
        this.terrain = terrain;
        this.objects = [];
      }

      Node.prototype.addObject = function(object) {
        return this.objects.push(object);
      };

      return Node;

    })();
  });

}).call(this);
