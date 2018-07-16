/* 
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */


/*jslint node: true, vars: true, evil: true, bitwise: true */
"use strict";
/* global mAllObjects, dt, gEngine */

function RigidShape(center) {

    this.mCenter = center;
    this.color = Math.floor(Math.random() * (7 - 1 + 1)) + 1;
    //angle
    this.mAngle = 0;
    this.mBoundRadius = 0;
    gEngine.Core.mAllObjects.push(this);
}

RigidShape.prototype.update = function () {
    
    switch(this.mSide) {
        case 1: // up
            this.move(new Vec2(0, 2));
            break;
        case 2: // down
            this.move(new Vec2(0, -2));
            break;
        case 3: // left
            this.move(new Vec2(2, 0));
            break;
        case 4: // right
            this.move(new Vec2(-2, 0));
            break;
        default:
            break;
    }



        
};

RigidShape.prototype.boundTest = function (otherShape) {
    var vFrom1to2 = otherShape.mCenter.subtract(this.mCenter);
    var rSum = this.mBoundRadius + otherShape.mBoundRadius;
    var dist = vFrom1to2.length();
    if (dist > rSum) {
        //not overlapping
        return false;
    }
    return true;
};
