// Jinnie Choi @65406900 and Inho Lee @95105502

/*
 * Global variables
 */
var meshResolution;

// Particle states
var mass;
var vertexPosition, vertexNormal;
var vertexVelocity;

// Spring properties
var K, restLength; 

// Force parameters
var Cd;
var uf, Cv;


/*
 * Getters and setters
 */
function getPosition(i, j) {
    var id = i*meshResolution + j;
    return vec3.create([vertexPosition[3*id], vertexPosition[3*id + 1], vertexPosition[3*id + 2]]);
}

function setPosition(i, j, x) {
    var id = i*meshResolution + j;
    vertexPosition[3*id] = x[0]; vertexPosition[3*id + 1] = x[1]; vertexPosition[3*id + 2] = x[2];
}

function getNormal(i, j) {
    var id = i*meshResolution + j;
    return vec3.create([vertexNormal[3*id], vertexNormal[3*id + 1], vertexNormal[3*id + 2]]);
}

function getVelocity(i, j) {
    var id = i*meshResolution + j;
    return vec3.create(vertexVelocity[id]);
}

function setVelocity(i, j, v) {
    var id = i*meshResolution + j;
    vertexVelocity[id] = vec3.create(v);
}


/*
 * Provided global functions (you do NOT have to modify them)
 */
function computeNormals() {
    var dx = [1, 1, 0, -1, -1, 0], dy = [0, 1, 1, 0, -1, -1];
    var e1, e2;
    var i, j, k = 0, t;
    for ( i = 0; i < meshResolution; ++i )
        for ( j = 0; j < meshResolution; ++j ) {
            var p0 = getPosition(i, j), norms = [];
            for ( t = 0; t < 6; ++t ) {
                var i1 = i + dy[t], j1 = j + dx[t];
                var i2 = i + dy[(t + 1) % 6], j2 = j + dx[(t + 1) % 6];
                if ( i1 >= 0 && i1 < meshResolution && j1 >= 0 && j1 < meshResolution &&
                     i2 >= 0 && i2 < meshResolution && j2 >= 0 && j2 < meshResolution ) {
                    e1 = vec3.subtract(getPosition(i1, j1), p0);
                    e2 = vec3.subtract(getPosition(i2, j2), p0);
                    norms.push(vec3.normalize(vec3.cross(e1, e2)));
                }
            }
            e1 = vec3.create();
            for ( t = 0; t < norms.length; ++t ) vec3.add(e1, norms[t]);
            vec3.normalize(e1);
            vertexNormal[3*k] = e1[0];
            vertexNormal[3*k + 1] = e1[1];
            vertexNormal[3*k + 2] = e1[2];
            ++k;
        }
}


var clothIndex, clothWireIndex;
function initMesh() {
    var i, j, k;

    vertexPosition = new Array(meshResolution*meshResolution*3);
    vertexNormal = new Array(meshResolution*meshResolution*3);
    clothIndex = new Array((meshResolution - 1)*(meshResolution - 1)*6);
    clothWireIndex = [];

    vertexVelocity = new Array(meshResolution*meshResolution);
    restLength[0] = 4.0/(meshResolution - 1);
    restLength[1] = Math.sqrt(2.0)*4.0/(meshResolution - 1);
    restLength[2] = 2.0*restLength[0];

    for ( i = 0; i < meshResolution; ++i )
        for ( j = 0; j < meshResolution; ++j ) {
            setPosition(i, j, [-2.0 + 4.0*j/(meshResolution - 1), -2.0 + 4.0*i/(meshResolution - 1), 0.0]);
            setVelocity(i, j, vec3.create());

            if ( j < meshResolution - 1 )
                clothWireIndex.push(i*meshResolution + j, i*meshResolution + j + 1);
            if ( i < meshResolution - 1 )
                clothWireIndex.push(i*meshResolution + j, (i + 1)*meshResolution + j);
            if ( i < meshResolution - 1 && j < meshResolution - 1 )
                clothWireIndex.push(i*meshResolution + j, (i + 1)*meshResolution + j + 1);
        }
    computeNormals();

    k = 0;
    for ( i = 0; i < meshResolution - 1; ++i )
        for ( j = 0; j < meshResolution - 1; ++j ) {
            clothIndex[6*k] = i*meshResolution + j;
            clothIndex[6*k + 1] = i*meshResolution + j + 1;
            clothIndex[6*k + 2] = (i + 1)*meshResolution + j + 1;
            clothIndex[6*k + 3] = i*meshResolution + j;
            clothIndex[6*k + 4] = (i + 1)*meshResolution + j + 1;            
            clothIndex[6*k + 5] = (i + 1)*meshResolution + j;
            ++k;
        }
}

function springForce(p, q, spring) {
	return vec3.scale(vec3.subtract(vec3.create(p), q), K[spring]*(restLength[spring]-vec3.length(vec3.subtract(vec3.create(p), q)))/vec3.length(vec3.subtract(vec3.create(p), q)));
}
/*
 * KEY function: simulate one time-step using Euler's method
 */
function simulate(stepSize) {
	newPosition = new Array(meshResolution*meshResolution);
    newVelocity  = new Array(meshResolution*meshResolution);

    for(i = 0; i < meshResolution*meshResolution; ++i) {
        newPosition[i] = vec3.create();
        newVelocity[i] = vec3.create();
    }

    for (i = 0; i < meshResolution; ++i) {
        for (j = 0; j < meshResolution; ++j) {
        	
        	var temp = meshResolution - 1;
            var gravity = vec3.create();
            
            gravity[1] = gravity[1] - mass * 9.8;
            vec3.add(gravity, vec3.scale(getVelocity(i, j), -Cd));
            vec3.add(gravity, vec3.scale(getNormal(i, j), Cv * vec3.dot(getNormal(i , j), vec3.subtract(vec3.create(uf), getVelocity(i, j)))));

            // structural
            if (j < temp) {
                vec3.add(gravity, springForce(getPosition(i, j), getPosition(i, j + 1), 0));
            }

            if (j > 0) {
                vec3.add(gravity, springForce(getPosition(i, j), getPosition(i, j - 1), 0));
            }

            if (i < temp) {
                vec3.add(gravity, springForce(getPosition(i, j), getPosition(i + 1, j), 0));
            }

            if (i > 0) {
                vec3.add(gravity, springForce(getPosition(i, j), getPosition(i - 1, j), 0));
            }
            
            // shear
            if (i < temp && j < temp) {
                vec3.add(gravity, springForce(getPosition(i, j),getPosition(i + 1, j + 1), 1));
            }

            if (i < temp && j > 0) {
                vec3.add(gravity, springForce(getPosition(i, j), getPosition(i + 1, j - 1), 1));
            }

            if (i > 0 && j > 0) {
                vec3.add(gravity, springForce(getPosition(i, j), getPosition(i - 1, j - 1), 1));
            }

            if (i > 0 && j < temp) {
                vec3.add(gravity, springForce(getPosition(i, j), getPosition(i - 1, j + 1), 1));
            }
            
            // flexion
            if (j < temp - 1) {
                vec3.add(gravity, springForce(getPosition(i, j), getPosition(i, j + 2), 2));
            }

            if (j > 1) {
                vec3.add(gravity, springForce(getPosition(i, j), getPosition(i, j - 2), 2));
            }
            
            if (i < temp - 1) {
                vec3.add(gravity, springForce(getPosition(i, j), getPosition(i + 2, j), 2));
            }

            if (i > 1) {
                vec3.add(gravity, springForce(getPosition(i, j), getPosition(i - 2, j), 2));
            }

            if ((i == temp && j == 0) || (i == temp && j == temp)) {
                newPosition[i * meshResolution + j] = getPosition(i, j);
            }

            else {
                newVelocity[i * meshResolution + j] = vec3.add(getVelocity(i, j), vec3.scale(gravity, stepSize/mass));
                newPosition[i * meshResolution + j] = vec3.add(getPosition(i, j), vec3.scale(vec3.create(newVelocity[i * meshResolution + j]), stepSize));
            }
        }
    }

    for (i = 0; i < meshResolution; ++i) {
        for (j = 0; j < meshResolution; ++j) {
            setPosition(i, j, newPosition[i * meshResolution + j]);
            setVelocity(i, j, newVelocity[i * meshResolution + j]);
        }
    } 
}
