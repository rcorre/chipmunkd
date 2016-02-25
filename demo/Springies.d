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
 
import core.stdc.string;

import chipmunk.chipmunk;
import ChipmunkDemo;

static cpFloat
springForce(cpConstraint *spring, cpFloat dist)
{
	cpFloat clamp = 20.0f;
	return cpfclamp(cpDampedSpringGetRestLength(spring) - dist, -clamp, clamp)*cpDampedSpringGetStiffness(spring);
}

static cpConstraint *
new_spring(cpBody *a, cpBody *b, cpVect anchorA, cpVect anchorB, cpFloat restLength, cpFloat stiff, cpFloat damp)
{
	cpConstraint *spring = cpDampedSpringNew(a, b, anchorA, anchorB, restLength, stiff, damp);
	cpDampedSpringSetSpringForceFunc(spring, springForce);
	
	return spring;
}

static void
update(cpSpace *space, double dt)
{
	cpSpaceStep(space, dt);
}

static cpBody *
add_bar(cpSpace *space, cpVect a, cpVect b, int group)
{
	cpVect center = cpvmult(cpvadd(a, b), 1.0f/2.0f);
	cpFloat length = cpvlength(cpvsub(b, a));
	cpFloat mass = length/160.0f;
	
	cpBody *body_ = cpSpaceAddBody(space, cpBodyNew(mass, mass*length*length/12.0f));
	cpBodySetPosition(body_, center);
	
	cpShape *shape = cpSpaceAddShape(space, cpSegmentShapeNew(body_, cpvsub(a, center), cpvsub(b, center), 10.0f));
	cpShapeSetFilter(shape, cpShapeFilterNew(group, CP_ALL_CATEGORIES, CP_ALL_CATEGORIES));
	
	return body_;
}

static cpSpace *
init(void)
{
	cpSpace *space = cpSpaceNew();
	cpBody *staticBody = cpSpaceGetStaticBody(space);
	
	cpBody *body_1  = add_bar(space, cpv(-240,  160), cpv(-160,   80), 1);
	cpBody *body_2  = add_bar(space, cpv(-160,   80), cpv( -80,  160), 1);
	cpBody *body_3  = add_bar(space, cpv(   0,  160), cpv(  80,    0), 0);
	cpBody *body_4  = add_bar(space, cpv( 160,  160), cpv( 240,  160), 0);
	cpBody *body_5  = add_bar(space, cpv(-240,    0), cpv(-160,  -80), 2);
	cpBody *body_6  = add_bar(space, cpv(-160,  -80), cpv( -80,    0), 2);
	cpBody *body_7  = add_bar(space, cpv( -80,    0), cpv(   0,    0), 2);
	cpBody *body_8  = add_bar(space, cpv(   0,  -80), cpv(  80,  -80), 0);
	cpBody *body_9  = add_bar(space, cpv( 240,   80), cpv( 160,    0), 3);
	cpBody *body_10 = add_bar(space, cpv( 160,    0), cpv( 240,  -80), 3);
	cpBody *body_11 = add_bar(space, cpv(-240,  -80), cpv(-160, -160), 4);
	cpBody *body_12 = add_bar(space, cpv(-160, -160), cpv( -80, -160), 4);
	cpBody *body_13 = add_bar(space, cpv(   0, -160), cpv(  80, -160), 0);
	cpBody *body_14 = add_bar(space, cpv( 160, -160), cpv( 240, -160), 0);
	
	cpSpaceAddConstraint(space, cpPivotJointNew2( body_1,  body_2, cpv( 40,-40), cpv(-40,-40)));
	cpSpaceAddConstraint(space, cpPivotJointNew2( body_5,  body_6, cpv( 40,-40), cpv(-40,-40)));
	cpSpaceAddConstraint(space, cpPivotJointNew2( body_6,  body_7, cpv( 40, 40), cpv(-40,  0)));
	cpSpaceAddConstraint(space, cpPivotJointNew2( body_9, body_10, cpv(-40,-40), cpv(-40, 40)));
	cpSpaceAddConstraint(space, cpPivotJointNew2(body11, body_12, cpv( 40,-40), cpv(-40,  0)));
	
	cpFloat stiff = 100.0f;
	cpFloat damp = 0.5f;
	cpSpaceAddConstraint(space, new_spring(staticBody,  body_1, cpv(-320,  240), cpv(-40, 40), 0.0f, stiff, damp));
	cpSpaceAddConstraint(space, new_spring(staticBody,  body_1, cpv(-320,   80), cpv(-40, 40), 0.0f, stiff, damp));
	cpSpaceAddConstraint(space, new_spring(staticBody,  body_1, cpv(-160,  240), cpv(-40, 40), 0.0f, stiff, damp));

	cpSpaceAddConstraint(space, new_spring(staticBody,  body_2, cpv(-160,  240), cpv( 40, 40), 0.0f, stiff, damp));
	cpSpaceAddConstraint(space, new_spring(staticBody,  body_2, cpv(   0,  240), cpv( 40, 40), 0.0f, stiff, damp));

	cpSpaceAddConstraint(space, new_spring(staticBody,  body_3, cpv(  80,  240), cpv(-40, 80), 0.0f, stiff, damp));

	cpSpaceAddConstraint(space, new_spring(staticBody,  body_4, cpv(  80,  240), cpv(-40,  0), 0.0f, stiff, damp));
	cpSpaceAddConstraint(space, new_spring(staticBody,  body_4, cpv( 320,  240), cpv( 40,  0), 0.0f, stiff, damp));

	cpSpaceAddConstraint(space, new_spring(staticBody,  body_5, cpv(-320,   80), cpv(-40, 40), 0.0f, stiff, damp));
	
	cpSpaceAddConstraint(space, new_spring(staticBody,  body_9, cpv( 320,  80), cpv( 40, 40), 0.0f, stiff, damp));

	cpSpaceAddConstraint(space, new_spring(staticBody, body_10, cpv( 320,   0), cpv( 40,-40), 0.0f, stiff, damp));
	cpSpaceAddConstraint(space, new_spring(staticBody, body_10, cpv( 320,-160), cpv( 40,-40), 0.0f, stiff, damp));

	cpSpaceAddConstraint(space, new_spring(staticBody, body_11, cpv(-320,-160), cpv(-40, 40), 0.0f, stiff, damp));

	cpSpaceAddConstraint(space, new_spring(staticBody, body_12, cpv(-240,-240), cpv(-40,  0), 0.0f, stiff, damp));
	cpSpaceAddConstraint(space, new_spring(staticBody, body_12, cpv(   0,-240), cpv( 40,  0), 0.0f, stiff, damp));

	cpSpaceAddConstraint(space, new_spring(staticBody, body_13, cpv(   0,-240), cpv(-40,  0), 0.0f, stiff, damp));
	cpSpaceAddConstraint(space, new_spring(staticBody, body_13, cpv(  80,-240), cpv( 40,  0), 0.0f, stiff, damp));

	cpSpaceAddConstraint(space, new_spring(staticBody, body_14, cpv(  80,-240), cpv(-40,  0), 0.0f, stiff, damp));
	cpSpaceAddConstraint(space, new_spring(staticBody, body_14, cpv( 240,-240), cpv( 40,  0), 0.0f, stiff, damp));
	cpSpaceAddConstraint(space, new_spring(staticBody, body_14, cpv( 320,-160), cpv( 40,  0), 0.0f, stiff, damp));

	cpSpaceAddConstraint(space, new_spring( body_1,  body_5, cpv( 40,-40), cpv(-40, 40), 0.0f, stiff, damp));
	cpSpaceAddConstraint(space, new_spring( body_1,  body_6, cpv( 40,-40), cpv( 40, 40), 0.0f, stiff, damp));
	cpSpaceAddConstraint(space, new_spring( body_2,  body_3, cpv( 40, 40), cpv(-40, 80), 0.0f, stiff, damp));
	cpSpaceAddConstraint(space, new_spring( body_3,  body_4, cpv(-40, 80), cpv(-40,  0), 0.0f, stiff, damp));
	cpSpaceAddConstraint(space, new_spring( body_3,  body_4, cpv( 40,-80), cpv(-40,  0), 0.0f, stiff, damp));
	cpSpaceAddConstraint(space, new_spring( body_3,  body_7, cpv( 40,-80), cpv( 40,  0), 0.0f, stiff, damp));
	cpSpaceAddConstraint(space, new_spring( body_3,  body_7, cpv(-40, 80), cpv(-40,  0), 0.0f, stiff, damp));
	cpSpaceAddConstraint(space, new_spring( body_3,  body_8, cpv( 40,-80), cpv( 40,  0), 0.0f, stiff, damp));
	cpSpaceAddConstraint(space, new_spring( body_3,  body_9, cpv( 40,-80), cpv(-40,-40), 0.0f, stiff, damp));
	cpSpaceAddConstraint(space, new_spring( body_4,  body_9, cpv( 40,  0), cpv( 40, 40), 0.0f, stiff, damp));
	cpSpaceAddConstraint(space, new_spring( body_5, body_11, cpv(-40, 40), cpv(-40, 40), 0.0f, stiff, damp));
	cpSpaceAddConstraint(space, new_spring( body_5, body_11, cpv( 40,-40), cpv( 40,-40), 0.0f, stiff, damp));
	cpSpaceAddConstraint(space, new_spring( body_7,  body_8, cpv( 40,  0), cpv(-40,  0), 0.0f, stiff, damp));
	cpSpaceAddConstraint(space, new_spring( body_8, body_12, cpv(-40,  0), cpv( 40,  0), 0.0f, stiff, damp));
	cpSpaceAddConstraint(space, new_spring( body_8, body_13, cpv(-40,  0), cpv(-40,  0), 0.0f, stiff, damp));
	cpSpaceAddConstraint(space, new_spring( body_8, body_13, cpv( 40,  0), cpv( 40,  0), 0.0f, stiff, damp));
	cpSpaceAddConstraint(space, new_spring( body_8, body_14, cpv( 40,  0), cpv(-40,  0), 0.0f, stiff, damp));
	cpSpaceAddConstraint(space, new_spring(body10, body_14, cpv( 40,-40), cpv(-40,  0), 0.0f, stiff, damp));
	cpSpaceAddConstraint(space, new_spring(body10, body_14, cpv( 40,-40), cpv(-40,  0), 0.0f, stiff, damp));
	
	return space;
}

static void
destroy(cpSpace *space)
{
	ChipmunkDemoFreeSpaceChildren(space);
	cpSpaceFree(space);
}

ChipmunkDemo Springies = {
	"Springies",
	1.0/60.0,
	init,
	update,
	ChipmunkDemoDefaultDrawImpl,
	destroy,
};
