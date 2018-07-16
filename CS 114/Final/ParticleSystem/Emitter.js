/*jslint node: true, vars: true, evil: true, bitwise: true */
"use strict";

var Emitter = function (point, velocity, spread) {
    this.position = point; // Vector
    this.velocity = velocity; // Vector
    this.spread = spread || Math.PI; // possible angles = velocity +/- spread
    this.drawColor = "#999"; // So we can tell them apart from Fields later
};

Emitter.prototype.emitParticle = function() {
    // Use an angle randomized over the spread so we have more of a "spray"
    var angle = this.velocity.getAngle() + this.spread - (Math.random() * this.spread * 2);

    // The magnitude of the emitter's velocity
    var magnitude = this.velocity.length();

    // The emitter's position
    var position = new Vec2(this.position.x, this.position.y);

    // New velocity based off of the calculated angle and magnitude
    var velocity = Vec2.fromAngle(angle, magnitude);

     //return our new Particle!
    return new Particle(position,velocity);
};
