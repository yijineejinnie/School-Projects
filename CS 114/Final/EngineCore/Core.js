/* 
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

/*jslint node: true, vars: true, evil: true, bitwise: true */
/*global  requestAnimationFrame: false */
/*global document,gObjectNum,dead */
"use strict";  // Operate in Strict mode such that variables must be declared before used!

/**
 * Static refrence to gEngine
 * @type gEngine
 */

var dead = false;
var reset = 0;
var gEngine = gEngine || {};
// initialize the variable while ensuring it is not redefined
gEngine.Core = (function () {
    var mCanvas, mContext, mWidth = 800, mHeight = 450;
    mCanvas = document.getElementById('canvas');
    mContext = mCanvas.getContext('2d');
            
                
    mCanvas.height = mHeight;
    mCanvas.width = mWidth;
    var particles = [];
                var level = 1;
    // Add one emitter located at `{ x : 100, y : 230}` from the origin (top left)
    // that emits at a velocity of `2` shooting out from the right (angle `0`)
                var emitters;

    var maxParticles = 80; // experiment! 20,000 provides a nice galaxy
    var emissionRate = 4; // how many particles are emitted each frame
                    var particleSize = 3;
                var color;
    var mCurrentTime, mElapsedTime, mPreviousTime = Date.now(), mLagTime = 0;
    var kFPS = 60;          // Frames per second
    var kFrameTime = 1 / kFPS;
    var mUpdateIntervalInSeconds = kFrameTime;
    var kMPF = 1000 * kFrameTime; // Milliseconds per frame.
    var mAllObjects = [];
            
    var rateOfBalls = 14;
    var minimum = 1;
    var maximum = 4;
    var sideToSpawn;
    var oncomingBall;
    var drawCount = 0;
        var score = 0;
                var explosionCount = 0;
                
    // MARK: - ADD NEW PARTICLES
    var addNewParticles = function () {
                if (reset == 1) {
                particles = [];
                reset = 0;
                }
                // if we're at our max, stop emitting.
                if (particles.length > maxParticles) return;
                
                // for each emitter
                for (var i = 0; i < emitters.length; i++) {
                
                // for [emissionRate], emit a particle
                for (var j = 0; j < emissionRate; j++) {
                particles.push(emitters[i].emitParticle());
                }
                
                }

    };
    
                
    // MARK: - PLOT PARTICLES
    var plotParticles = function (boundsX, boundsY) {
//                // a new array to hold particles within our bounds
//                var currentParticles = [];
//
//                for (var i = 0; i < particles.length; i++) {
//                var particle = particles[i];
//                var pos = particle.position;
//
//                // If we're out of bounds, drop this particle and move on to the next
//                if (pos.x < 0 || pos.x > boundsX || pos.y < 0 || pos.y > boundsY) continue;
//
//                // Move our particles
//                particle.move();
//                //particle.position = new Vec2(Math.random() * mWidth, Math.random() *mHeight);
//
//                // Add this particle to the list of current particles
//                currentParticles.push(particle);
//                }
//
//                // Update our global particles, clearing room for old particles to be collected
//                particles = currentParticles;
                var currentParticles = [];
                
                                for (var i = 0; i < particles.length; i++) {
                                var particle = particles[i];
                                var pos = particle.position;
                
                                // If we're out of bounds, drop this particle and move on to the next
                                if (pos.x < -10 || pos.x > boundsX+10 || pos.y < -10 || pos.y > boundsY+10) continue;
                
                                // Move our particles
                                particles[i].move();
                                //particle.position = new Vec2(Math.random() * mWidth, Math.random() *mHeight);
                
                                // Add this particle to the list of current particles
                
                                }
                
                                // Update our global particles, clearing room for old particles to be collected
                
                
                

    };
                

                
    var drawParticles = function () {
         //Set the color of our particles
        mContext.fillStyle = 'red';
                mContext.strokeStyle = 'red';

        // For each particle
                var i;
        for (i = 0; i < particles.length; i++) {
            var position = particles[i].position;
            // Draw a square at our position [particleSize] wide and tall
                //position = new Vec2(Math.random() * mWidth, 300);
           // mContext.fillRect(position.x, position.y, particleSize, particleSize);
                mContext.beginPath();
                mContext.arc(position.x, position.y, particleSize, 0, Math.PI * 2, true);
                mContext.closePath();
                mContext.fill();
                mContext.stroke();

        }
    };


                
    // MARK: - UPDATE UI ECHO
    var updateUIEcho = function () {
        document.getElementById("uiEchoString").innerHTML =
                "<ul style=\"margin:-10px\">" +
                "Level: " + level + "<br/>" +
                "Score: " + score;
                
    };
                
    // MARK: - DRAW
    var draw = function () {

        mContext.fillStyle = "black";
        mContext.fillRect(0, 0, mWidth, mHeight);
                
                
                if (dead) {
    
                    emitters = [new Emitter(new Vec2(mAllObjects[gObjectNum].mCenter.x, mAllObjects[gObjectNum].mCenter.y), Vec2.fromAngle(0, 7))];
                    addNewParticles();
                    plotParticles(mWidth, mHeight);
                    drawParticles();
                
                }
                else {
                score++;
                }
                
        sideToSpawn = Math.floor(Math.random() * (maximum - minimum + 1)) + minimum;
                
                if (score % 1000 == 0) {
                level++;
                rateOfBalls--;
                }
                
        if (drawCount >= rateOfBalls) {
            switch(sideToSpawn) {
                case 1: // Top
                oncomingBall = new Circle(new Vec2(Math.random() * mWidth, -30),Math.random() * 10 + 10,1);
                break;
                case 2: // Bottom
                oncomingBall = new Circle(new Vec2(Math.random() * mWidth, mHeight+30),Math.random() * 10 + 10,2);
                break;
                case 3: // Left
                oncomingBall = new Circle(new Vec2(-30, Math.random() * mHeight),Math.random() * 10 + 10,3);
                break;
                case 4: // Right
                oncomingBall = new Circle(new Vec2(mWidth+30, Math.random() * mHeight),Math.random() * 10 + 10,4);
                break;
                default:
                break;
            }
            drawCount = 0;
        }
                
        // Limit player movement within boundaries
        if (mAllObjects[0].mCenter.y <= mAllObjects[0].mRadius+2) {
            mAllObjects[0].mCenter.y = mAllObjects[0].mRadius+2;
        }
        if (mAllObjects[0].mCenter.y >= mHeight - mAllObjects[0].mRadius - 2) {
            mAllObjects[0].mCenter.y = mHeight - mAllObjects[0].mRadius - 2;
        }
        if (mAllObjects[0].mCenter.x <= mAllObjects[0].mRadius+2) {
            mAllObjects[0].mCenter.x = mAllObjects[0].mRadius+2;
        }
        if (mAllObjects[0].mCenter.x >= mWidth - mAllObjects[0].mRadius - 2) {
            mAllObjects[0].mCenter.x = mWidth - mAllObjects[0].mRadius - 2;
        }
                
                
                
                
                
        var i = 0;
        if (dead) {
               // mAllObjects[0].mCenter = Vec2(width / 2, height / 2);
            i = 1;
            
        }
        for (i; i < mAllObjects.length; i++) {
             
                if (gEngine.Core.mAllObjects[i].color == 1) {
                
                mContext.strokeStyle = 'orange';
                mContext.fillStyle = 'orange';
                }
                else if (gEngine.Core.mAllObjects[i].color == 2) {
                
                mContext.strokeStyle = 'yellow';
                mContext.fillStyle = 'yellow';
                }
                else if (gEngine.Core.mAllObjects[i].color == 3) {
                mContext.fillStyle = 'green';
                mContext.strokeStyle = 'green';
                }
                else if (gEngine.Core.mAllObjects[i].color == 4) {
                mContext.fillStyle = 'blue';
                mContext.strokeStyle = 'blue';
                }
                else if (gEngine.Core.mAllObjects[i].color == 5) {
                mContext.fillStyle = 'purple';
                mContext.strokeStyle = 'purple';
                }
                else if (gEngine.Core.mAllObjects[i].color == 6) {
                mContext.fillStyle = 'aqua';
                mContext.strokeStyle = 'aqua';
                }
                else if (gEngine.Core.mAllObjects[i].color == 7) {
                mContext.fillStyle = 'magenta';
                mContext.strokeStyle = 'magenta';
                }
                
                if (i === gObjectNum) {
                mContext.fillStyle = 'red';
                mContext.strokeStyle = 'red';
                }
                if (i >= 1 && i <= 4) {
                mContext.strokeStyle = 'black';
                }
                
            
            mAllObjects[i].draw(mContext);
                
        }
    
        for (i = 5; i < mAllObjects.length; i++) {
            if (gEngine.Core.mAllObjects[i].mCenter.y <= -40 ||
                gEngine.Core.mAllObjects[i].mCenter.y >= mHeight+40 ||
                gEngine.Core.mAllObjects[i].mCenter.x <= -40 ||
                gEngine.Core.mAllObjects[i].mCenter.x >= mWidth+40) {
                    gEngine.Core.mAllObjects.splice(i,1);
            }
        }
        drawCount++;
    };
                
    
    // MARK: - UPDATE
    var update = function () {
                

                var i;
                
        for (i = 0; i < mAllObjects.length; i++) {
            mAllObjects[i].update(mContext);
        }
                
        
    };
                
                
    // MARK: - GAME LOOP
    var runGameLoop = function () {
        requestAnimationFrame(function () {
            runGameLoop();
        });

        // compute how much time has elapsed since we last runGameLoop was executed
        mCurrentTime = Date.now();
        mElapsedTime = mCurrentTime - mPreviousTime;
        mPreviousTime = mCurrentTime;
        mLagTime += mElapsedTime;

        updateUIEcho();
        draw();
        // Make sure we update the game the appropriate number of times.
        // Update only every Milliseconds per frame.
        // If lag larger then update frames, update until caught up.
        while (mLagTime >= kMPF) {
            mLagTime -= kMPF;
            gEngine.Physics.collision();
            update();
        }
    };
                
    // MARK: - INITIALIZE ENGINE CORE
    var initializeEngineCore = function () {
            
        runGameLoop();
    };
                
    // MARK: - PUBLIC VARIABLES
    var mPublic = {
        particles: particles,
        initializeEngineCore: initializeEngineCore,
        mAllObjects: mAllObjects,
        mWidth: mWidth,
        mHeight: mHeight,
        mContext: mContext,
        mUpdateIntervalInSeconds: mUpdateIntervalInSeconds
    };
    return mPublic;
}());
