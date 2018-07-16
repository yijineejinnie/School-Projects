/* 
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

/* global mAllObjects, gEngine, dead */
/*jslint node: true, vars: true, evil: true, bitwise: true */
"use strict";


var gObjectNum = 0;
function userControl(event) {
    var keycode;
    if (window.event) {// IE
        keycode = event.keyCode;
    } else if (event.which) {// Netscape/Firefox/Opera  
        keycode = event.which;
    }
    
    
//    if (keycode >= 48 && keycode <= 57) {
//        if (keycode - 48 < gEngine.Core.mAllObjects.length) {
//            gObjectNum = keycode - 48;
//        }
//    }
//
//
//    if (keycode === 38) { //up arrow
//        if (gObjectNum > 0) {
//            gObjectNum--;
//        }
//    }
//    if (keycode === 40) {// down arrow
//        if (gObjectNum < gEngine.Core.mAllObjects.length - 1) {
//            gObjectNum++;
//        }
//    }
    

    // move with WASD keys
    
    if (!dead) {
    if (keycode === 87) { //W
        gEngine.Core.mAllObjects[gObjectNum].move(new Vec2(0, -20));
    }
    if (keycode === 83) { // S
        gEngine.Core.mAllObjects[gObjectNum].move(new Vec2(0, +20));
    }
    if (keycode === 65) { //A
        gEngine.Core.mAllObjects[gObjectNum].move(new Vec2(-20, 0));
    }
    if (keycode === 68) { //D
        gEngine.Core.mAllObjects[gObjectNum].move(new Vec2(20, 0));
    }
    }

    
    // Rotate with QE keys
//    if (keycode === 81) { //Q
//        gEngine.Core.mAllObjects[gObjectNum].rotate(-0.1);
//    }
//    if (keycode === 69) { //E
//        gEngine.Core.mAllObjects[gObjectNum].rotate(0.1);
//    }
//
//    if (keycode === 70) {//f
//        var r1 = new Rectangle(new Vec2(gEngine.Core.mAllObjects[gObjectNum].mCenter.x,
//                gEngine.Core.mAllObjects[gObjectNum].mCenter.y),
//                Math.random() * 30 + 10, Math.random() * 30 + 10);
//    }
//    if (keycode === 71) {//g
//        var r1 = new Circle(new Vec2(gEngine.Core.mAllObjects[gObjectNum].mCenter.x,
//                gEngine.Core.mAllObjects[gObjectNum].mCenter.y),
//                Math.random() * 10 + 20);
//    }
///
//    if (keycode === 82) { //R
//        gEngine.Core.mAllObjects.splice(5, gEngine.Core.mAllObjects.length);
//        gEngine.Core.mAllObjects[0].mCenter = new Vec2(width / 2, height / 2);
//        gEngine.Core.particles.splice(0, gEngine.Core.particles.length);
//        dead = false;
//        reset = 1;
//        gObjectNum = 0;
//    }
}
