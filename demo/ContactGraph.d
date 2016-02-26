/* Copyright (c) 2007 Scott Lembcke
 * 
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 * 
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 * 
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 * SOFTWARE.
 */
 
import chipmunk;
import ChipmunkDemo;

// static body_ that we will be making into a scale
static cpBody *scaleStaticBody;
static cpBody *ballBody;

// If your compiler supports blocks (Clang or some GCC versions),
// You can use the block based iterators instead of the function ones to make your life easier.
static void
ScaleIterator(cpBody *body_, cpArbiter *arb, cpVect *sum)
{
	(*sum) = cpvadd(*sum, cpArbiterTotalImpulse(arb));
}

static void
BallIterator(cpBody *body_, cpArbiter *arb, int *count)
{
	// body_ is the body_ we are iterating the arbiters for.
	// CP_ARBITER_GET_*() in an arbiter iterator always returns the body_/shape for the iterated body_ first.
	CP_ARBITER_GET_SHAPES(arb, ball, other);
	ChipmunkDebugDrawBB(cpShapeGetBB(other), RGBAColor(1, 0, 0, 1));
	
	(*count)++;
}

struct CrushingContext {
	cpFloat magnitudeSum;
	cpVect vectorSum;
};

static void
EstimateCrushing(cpBody *body_, cpArbiter *arb, CrushingContext *context)
{
	cpVect j = cpArbiterTotalImpulse(arb);
	context.magnitudeSum += cpvlength(j);
	context.vectorSum = cpvadd(context.vectorSum, j);
}

static void
update(cpSpace *space, double dt)
{
	cpSpaceStep(space, dt);
	
	ChipmunkDemoPrintString("Place objects on the scale to weigh them. The ball marks the shapes it's sitting on.\n");
	
	// Sum the total impulse applied to the scale from all collision pairs in the contact graph.
	// If your compiler supports blocks, your life is a little easier.
	// You can use the "Block" versions of the functions without needing the callbacks above.
    cpVect impulseSum = cpvzero;
    cpBodyEachArbiter(scaleStaticBody, cast(cpBodyArbiterIteratorFunc)ScaleIterator, &impulseSum);
	
	// Force is the impulse divided by the timestep.
	cpFloat force = cpvlength(impulseSum)/dt;
		
	// Weight can be found similarly from the gravity vector.
	cpVect g = cpSpaceGetGravity(space);
	cpFloat weight = cpvdot(g, impulseSum)/(cpvlengthsq(g)*dt);
	
	ChipmunkDemoPrintString("Total force: %5.2f, Total weight: %5.2f. ", force, weight);
	
	
	// Highlight and count the number of shapes the ball is touching.
    int count = 0;
    cpBodyEachArbiter(ballBody, cast(cpBodyArbiterIteratorFunc)BallIterator, &count);
	
	ChipmunkDemoPrintString("The ball is touching %d shapes.\n", count);

    CrushingContext crush = {0.0f, cpvzero};
    cpBodyEachArbiter(ballBody, cast(cpBodyArbiterIteratorFunc)EstimateCrushing, &crush);

    cpFloat crushForce = (crush.magnitudeSum - cpvlength(crush.vectorSum))*dt;
	
	if(crushForce > 10.0f){
		ChipmunkDemoPrintString("The ball is being crushed. (f: %.2f)", crushForce);
	} else {
		ChipmunkDemoPrintString("The ball is not being crushed. (f: %.2f)", crushForce);
	}
}

enum WIDTH = 4.0f;
enum HEIGHT = 30.0f;

static cpSpace *
init()
{
	cpSpace *space = cpSpaceNew();
	cpSpaceSetIterations(space, 30);
	cpSpaceSetGravity(space, cpv(0, -300));
	cpSpaceSetCollisionSlop(space, 0.5);
	cpSpaceSetSleepTimeThreshold(space, 1.0f);
	
	cpBody *body_, staticBody = cpSpaceGetStaticBody(space);
	cpShape *shape;
	
	// Create segments around the edge of the screen.
	shape = cpSpaceAddShape(space, cpSegmentShapeNew(staticBody, cpv(-320,-240), cpv(-320,240), 0.0f));
	cpShapeSetElasticity(shape, 1.0f);
	cpShapeSetFriction(shape, 1.0f);
	cpShapeSetFilter(shape, NOT_GRABBABLE_FILTER);

	shape = cpSpaceAddShape(space, cpSegmentShapeNew(staticBody, cpv(320,-240), cpv(320,240), 0.0f));
	cpShapeSetElasticity(shape, 1.0f);
	cpShapeSetFriction(shape, 1.0f);
	cpShapeSetFilter(shape, NOT_GRABBABLE_FILTER);

	shape = cpSpaceAddShape(space, cpSegmentShapeNew(staticBody, cpv(-320,-240), cpv(320,-240), 0.0f));
	cpShapeSetElasticity(shape, 1.0f);
	cpShapeSetFriction(shape, 1.0f);
	cpShapeSetFilter(shape, NOT_GRABBABLE_FILTER);
	
	scaleStaticBody = cpSpaceAddBody(space, cpBodyNewStatic());
	shape = cpSpaceAddShape(space, cpSegmentShapeNew(scaleStaticBody, cpv(-240,-180), cpv(-140,-180), 4.0f));
	cpShapeSetElasticity(shape, 1.0f);
	cpShapeSetFriction(shape, 1.0f);
	cpShapeSetFilter(shape, NOT_GRABBABLE_FILTER);
	
	// add some boxes to stack on the scale
	for(int i=0; i<5; i++){
		body_ = cpSpaceAddBody(space, cpBodyNew(1.0f, cpMomentForBox(1.0f, 30.0f, 30.0f)));
		cpBodySetPosition(body_, cpv(0, i*32 - 220));
		
		shape = cpSpaceAddShape(space, cpBoxShapeNew(body_, 30.0f, 30.0f, 0.0));
		cpShapeSetElasticity(shape, 0.0f);
		cpShapeSetFriction(shape, 0.8f);
	}
	
	// Add a ball that we'll track which objects are beneath it.
	cpFloat radius = 15.0f;
	ballBody = cpSpaceAddBody(space, cpBodyNew(10.0f, cpMomentForCircle(10.0f, 0.0f, radius, cpvzero)));
	cpBodySetPosition(ballBody, cpv(120, -240 + radius+5));

	shape = cpSpaceAddShape(space, cpCircleShapeNew(ballBody, radius, cpvzero));
	cpShapeSetElasticity(shape, 0.0f);
	cpShapeSetFriction(shape, 0.9f);
	
	return space;
}

static void
destroy(cpSpace *space)
{
	ChipmunkDemoFreeSpaceChildren(space);
	cpSpaceFree(space);
}

ChipmunkDemo ContactGraph = {
	"Contact Graph",
	1.0/60.0,
	init,
	update,
	ChipmunkDemoDefaultDrawImpl,
	destroy,
};
