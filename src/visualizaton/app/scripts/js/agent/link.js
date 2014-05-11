(function() {
  var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

  define(['world/render'], function(Render) {
    var Link;
    return Link = (function() {
      function Link(x, y) {
        this.getOldLink = __bind(this.getOldLink, this);
        this.know = __bind(this.know, this);
        this.beingAttacked = __bind(this.beingAttacked, this);
        this.inVortex = __bind(this.inVortex, this);
        this.inHole = __bind(this.inHole, this);
        this.getHeart = __bind(this.getHeart, this);
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
        this.energy = 100;
        this.render = new Render();
      }

      Link.prototype.turnLeft = function() {
        var oldLink;
        this.action = '';
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
        this.action = '';
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
        var oldLink;
        this.action = '';
        oldLink = this.getOldLink();
        if (this.direction === 'up') {
          this.y = this.y - 1;
        } else if (this.direction === 'right') {
          this.x = this.x + 1;
        } else if (this.direction === 'down') {
          this.y = this.y + 1;
        } else if (this.direction === 'left') {
          this.x = this.x - 1;
        }
        return this.render.paintLink(oldLink, this);
      };

      Link.prototype.attack = function() {
        var oldLink;
        oldLink = this.getOldLink();
        this.action = 'attacking';
        return this.render.paintLink(oldLink, this);
      };

      Link.prototype.getRupee = function() {
        var oldLink;
        oldLink = this.getOldLink();
        this.action = 'get-rupee';
        return this.render.paintLink(oldLink, this);
      };

      Link.prototype.getSword = function() {
        var oldLink;
        oldLink = this.getOldLink();
        this.action = 'get-sword';
        return this.render.paintLink(oldLink, this);
      };

      Link.prototype.getHeart = function() {
        var oldLink;
        oldLink = this.getOldLink();
        this.action = 'get-heart';
        return this.render.paintLink(oldLink, this);
      };

      Link.prototype.inHole = function() {
        var oldLink;
        oldLink = this.getOldLink();
        this.action = 'falling';
        return this.render.paintLink(oldLink, this);
      };

      Link.prototype.inVortex = function() {
        var oldLink;
        oldLink = this.getOldLink();
        this.action = 'vortex';
        return this.render.paintLink(oldLink, this);
      };

      Link.prototype.beingAttacked = function() {
        var oldLink;
        oldLink = this.getOldLink();
        this.action = 'damage';
        return this.render.paintLink(oldLink, this);
      };

      Link.prototype.know = function(x, y) {
        return this.render.getPoint(x, y, 'div').addClass('know');
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
        return $('.energy').text(to);
      };

      Link.prototype.getOldLink = function() {
        var oldLink;
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
