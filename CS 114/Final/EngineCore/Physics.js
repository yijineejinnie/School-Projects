/*
 The following is not free software. You may use it for educational purposes, but you may not redistribute or use it commercially.
 (C) Burak Kanber 2012
 */
/* global objectNum, context, mRelaxationCount, mAllObjects, mPosCorrectionRate, dead */
/*jslint node: true, vars: true, evil: true, bitwise: true */
"use strict";
var gEngine = gEngine || {};
// initialize the variable while ensuring it is not redefined

gEngine.Physics = (function () {
    var drawCollisionInfo = function (collisionInfo, context) {
        context.beginPath();
        context.moveTo(collisionInfo.mStart.x, collisionInfo.mStart.y);
        context.lineTo(collisionInfo.mEnd.x, collisionInfo.mEnd.y);
        context.closePath();
        context.strokeStyle = "orange";
        context.stroke();
    };
    var collision = function () {
        var i, j;
        var collisionInfo = new CollisionInfo();
                   
            for (j = 5; j < gEngine.Core.mAllObjects.length; j++) {
                if (gEngine.Core.mAllObjects[0].boundTest(gEngine.Core.mAllObjects[j])) {
                    if (gEngine.Core.mAllObjects[0].collisionTest(gEngine.Core.mAllObjects[j], collisionInfo)) {
                        //make sure the normal is always from object[0] to object[j]
                        if (collisionInfo.getNormal().dot(gEngine.Core.mAllObjects[j].mCenter.subtract(gEngine.Core.mAllObjects[0].mCenter)) < 0) {
                            collisionInfo.changeDir();
                        }
                   
                        //draw collision info (a black line that shows normal)
                       // drawCollisionInfo(collisionInfo, gEngine.Core.mContext);
                   
                   dead = true;
                        // If collides, particle system explosion
                   
                   
                   
                    }
                }
            }
                   
            
                   
    };

    var mPublic = {
        collision: collision
    };

    return mPublic;
}());

