(function() {
  requirejs.config({
    baseUrl: 'scripts/js/'
  });

  requirejs(['world/render', 'world/grid'], function(Render, Grid) {
    var grid, render;
    render = new Render();
    return grid = new Grid();
  });

}).call(this);
