(function() {
  var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

  define(['world/render'], function(Render) {
    var Link;
    return Link = (function() {
      function Link(x, y) {
        this.getOldLink = __bind(this.getOldLink, this);
        this.getPointForward = __bind(this.getPointForward, this);
        this.changeEnergy = __bind(this.changeEnergy, this);
        this.changeCost = __bind(this.changeCost, this);
        this.removeObject = __bind(this.removeObject, this);
        this.know = __bind(this.know, this);
        this.teleport = __bind(this.teleport, this);
        this.getAttacked = __bind(this.getAttacked, this);
        this.goIntoVortex = __bind(this.goIntoVortex, this);
        this.fallDownHole = __bind(this.fallDownHole, this);
        this.getHeart = __bind(this.getHeart, this);
        this.getFakeSword = __bind(this.getFakeSword, this);
        this.getSword = __bind(this.getSword, this);
        this.getRupee = __bind(this.getRupee, this);
        this.attack = __bind(this.attack, this);
        this.moveForward = __bind(this.moveForward, this);
        this.turnRight = __bind(this.turnRight, this);
        this.turnLeft = __bind(this.turnLeft, this);
        this.x = x;
        this.y = y;
        this.direction = 'down';
        this.action = '';
        this.cost = 0;
        this.energy = 100;
        this.render = new Render();
      }

      Link.prototype.turnLeft = function() {
        var oldLink;
        this.changeCost(this.cost - 1);
        oldLink = this.getOldLink();
        if (this.direction === 'up') {
          this.direction = 'left';
        } else if (this.direction === 'left') {
          this.direction = 'down';
        } else if (this.direction === 'down') {
          this.direction = 'right';
        } else if (this.direction === 'right') {
          this.direction = 'up';
        }
        return this.render.paintLink(oldLink, this);
      };

      Link.prototype.turnRight = function() {
        var oldLink;
        this.changeCost(this.cost - 1);
        oldLink = this.getOldLink();
        if (this.direction === 'up') {
          this.direction = 'right';
        } else if (this.direction === 'right') {
          this.direction = 'down';
        } else if (this.direction === 'down') {
          this.direction = 'left';
        } else if (this.direction === 'left') {
          this.direction = 'up';
        }
        return this.render.paintLink(oldLink, this);
      };

      Link.prototype.moveForward = function() {
        var oldLink, _ref;
        this.changeCost(this.cost - 1);
        oldLink = this.getOldLink();
        _ref = this.getPointForward(), this.x = _ref[0], this.y = _ref[1];
        return this.render.paintLink(oldLink, this);
      };

      Link.prototype.attack = function() {
        var isMonsterThere, oldLink, x, y, _ref;
        oldLink = this.getOldLink();
        _ref = this.getPointForward(), x = _ref[0], y = _ref[1];
        isMonsterThere = this.render.getPoint(x, y, '.e');
        if (isMonsterThere[0]) {
          $(isMonsterThere[0]).fadeOut('slow', function() {
            return $(this).remove();
          });
          this.changeEnergy(this.energy - 10);
        }
        this.action = 'attack';
        return this.render.paintLink(oldLink, this);
      };

      Link.prototype.getRupee = function() {
        var oldLink;
        this.changeCost(this.cost + 10);
        oldLink = this.getOldLink();
        this.removeObject(this.x, this.y, '.r');
        this.action = 'get-rupee';
        return this.render.paintLink(oldLink, this);
      };

      Link.prototype.getSword = function() {
        var oldLink;
        this.changeCost(this.cost - 100);
        oldLink = this.getOldLink();
        this.removeObject(this.x, this.y, '.m');
        this.action = 'get-sword';
        return this.render.paintLink(oldLink, this);
      };

      Link.prototype.getFakeSword = function() {
        var oldLink;
        this.changeCost(this.cost - 100);
        oldLink = this.getOldLink();
        this.removeObject(this.x, this.y, '.f');
        this.action = 'get-sword';
        return this.render.paintLink(oldLink, this);
      };

      Link.prototype.getHeart = function() {
        var oldLink;
        this.changeCost(this.cost - 10);
        this.changeEnergy(this.energy + 50);
        oldLink = this.getOldLink();
        this.removeObject(this.x, this.y, '.c');
        this.action = 'get-heart';
        return this.render.paintLink(oldLink, this);
      };

      Link.prototype.fallDownHole = function() {
        var oldLink;
        this.changeCost(this.cost - 10000);
        this.changeEnergy(0);
        oldLink = this.getOldLink();
        this.action = 'falling';
        return this.render.paintLink(oldLink, this);
      };

      Link.prototype.goIntoVortex = function() {
        var oldLink;
        oldLink = this.getOldLink();
        this.action = 'vortex';
        return this.render.paintLink(oldLink, this);
      };

      Link.prototype.getAttacked = function() {
        var oldLink;
        this.changeCost(this.cost - 10000);
        this.changeEnergy(0);
        oldLink = this.getOldLink();
        this.action = 'damage';
        return this.render.paintLink(oldLink, this);
      };

      Link.prototype.teleport = function(x, y) {
        var oldLink, _ref;
        oldLink = this.getOldLink();
        _ref = [x, y], this.x = _ref[0], this.y = _ref[1];
        return this.render.paintLink(oldLink, this);
      };

      Link.prototype.know = function(x, y) {
        return this.render.getPoint(x, y, 'div').addClass('know');
      };

      Link.prototype.removeObject = function(x, y, object) {
        object = this.render.getPoint(x, y, object);
        if (object[0]) {
          $(object[0]).remove();
          return true;
        }
        return false;
      };

      Link.prototype.changeCost = function(to) {
        $('.cost').text(to);
        return this.cost = to;
      };

      Link.prototype.changeEnergy = function(to) {
        if (to <= 0) {
          $('.heart-1, .heart-2, .heart-3').removeClass('heart-full').addClass('heart-empty');
        } else if (to < 33) {
          $('.heart-1').removeClass('heart-empty').addClass('heart-full');
          $('.heart-2, .heart-3').removeClass('heart-full').addClass('heart-empty');
        } else if (to < 66) {
          $('.heart-1, .heart-2').removeClass('heart-empty').addClass('heart-full');
          $('.heart-3').removeClass('heart-full').addClass('heart-empty');
        } else {
          $('.heart-1, .heart-2, .heart-3').removeClass('heart-empty').addClass('heart-full');
        }
        $('.energy').text(to);
        return this.energy = to;
      };

      Link.prototype.getPointForward = function() {
        var x, y, _ref;
        _ref = [this.x, this.y], x = _ref[0], y = _ref[1];
        if (this.direction === 'up') {
          y = parseInt(y) - 1;
        } else if (this.direction === 'right') {
          x = parseInt(x) + 1;
        } else if (this.direction === 'down') {
          y = parseInt(y) + 1;
        } else if (this.direction === 'left') {
          x = parseInt(x) - 1;
        }
        return [x, y];
      };

      Link.prototype.getOldLink = function() {
        var oldLink;
        this.action = '';
        return oldLink = {
          x: this.x,
          y: this.y,
          direction: this.direction
        };
      };

      return Link;

    })();
  });

}).call(this);
