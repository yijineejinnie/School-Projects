
/*jslint node: true, vars: true, evil: true, bitwise: true */
"use strict";

var Particle = function (point, velocity, acceleration) {
    this.position = point || new Vec2(0, 0);
    this.velocity = velocity || new Vec2(0, 0);
    this.acceleration = acceleration || new Vec2(0, 0);
};

Particle.prototype.move = function () {
    // Add our current acceleration to our current velocity

    this.velocity.add(this.acceleration);
    
    // Add our current velocity to our position
    this.position = this.position.add(this.velocity);
};
