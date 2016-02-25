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

import std.stdio;
import chipmunk;
import allegro5.allegro;
import allegro5.allegro_color;
import allegro5.allegro_primitives;

static cpBody* tankBody, tankControlBody;
static cpBody*[50] boxes;

enum GRABBABLE_MASK_BIT = (1<<31);
cpShapeFilter GRAB_FILTER = {CP_NO_GROUP, GRABBABLE_MASK_BIT, GRABBABLE_MASK_BIT};
cpShapeFilter NOT_GRABBABLE_FILTER = {CP_NO_GROUP, ~GRABBABLE_MASK_BIT, ~GRABBABLE_MASK_BIT};

static cpVect mousePos() {
    int x, y;
    al_get_mouse_cursor_position(&x, &y);
    return cpv(x, y);
}

static cpFloat
frand()
{
    import std.random : uniform01;
	return uniform01();
}

// ---

static void
update(cpSpace *space, double dt)
{
	// turn the control body based on the angle relative to the actual body
	cpVect mouseDelta = cpvsub(mousePos(), cpBodyGetPosition(tankBody));
	cpFloat turn = cpvtoangle(cpvunrotate(cpBodyGetRotation(tankBody), mouseDelta));
	cpBodySetAngle(tankControlBody, cpBodyGetAngle(tankBody) - turn);

	// drive the tank towards the mouse
	if(cpvnear(mousePos(), cpBodyGetPosition(tankBody), 30.0)){
		cpBodySetVelocity(tankControlBody, cpvzero); // stop
	} else {
		cpFloat direction = (cpvdot(mouseDelta, cpBodyGetRotation(tankBody)) > 0.0 ? 1.0 : -1.0);
		cpBodySetVelocity(tankControlBody, cpvrotate(cpBodyGetRotation(tankBody), cpv(30.0f*direction, 0.0f)));
	}

	cpSpaceStep(space, dt);
}

static cpBody *
add_box(cpSpace *space, cpFloat size, cpFloat mass)
{
	cpFloat radius = cpvlength(cpv(size, size));

	cpBody *bod = cpSpaceAddBody(space, cpBodyNew(mass, cpMomentForBox(mass, size, size)));
	cpBodySetPosition(bod, cpv(frand()*(640 - 2*radius) - (320 - radius), frand()*(480 - 2*radius) - (240 - radius)));

	cpShape *shape = cpSpaceAddShape(space, cpBoxShapeNew(bod, size, size, 0.0));
	cpShapeSetElasticity(shape, 0.0f);
	cpShapeSetFriction(shape, 0.7f);

	return bod;
}

static cpSpace *
init()
{
	cpSpace *space = cpSpaceNew();
	cpSpaceSetIterations(space, 10);
	cpSpaceSetSleepTimeThreshold(space, 0.5f);

	cpBody *staticBody = cpSpaceGetStaticBody(space);
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

	shape = cpSpaceAddShape(space, cpSegmentShapeNew(staticBody, cpv(-320,240), cpv(320,240), 0.0f));
	cpShapeSetElasticity(shape, 1.0f);
	cpShapeSetFriction(shape, 1.0f);
	cpShapeSetFilter(shape, NOT_GRABBABLE_FILTER);

	for(int i=0; i<50; i++){
		cpBody *bod = add_box(space, 20, 1);

		cpConstraint *pivot = cpSpaceAddConstraint(space, cpPivotJointNew2(staticBody, bod, cpvzero, cpvzero));
		cpConstraintSetMaxBias(pivot, 0); // disable joint correction
		cpConstraintSetMaxForce(pivot, 1000.0f); // emulate linear friction

		cpConstraint *gear = cpSpaceAddConstraint(space, cpGearJointNew(staticBody, bod, 0.0f, 1.0f));
		cpConstraintSetMaxBias(gear, 0); // disable joint correction
		cpConstraintSetMaxForce(gear, 5000.0f); // emulate angular friction

        boxes[i] = bod;
	}

	// We joint the tank to the control body and control the tank indirectly by modifying the control body.
	tankControlBody = cpSpaceAddBody(space, cpBodyNewKinematic());
	tankBody = add_box(space, 30, 10);

	cpConstraint *pivot = cpSpaceAddConstraint(space, cpPivotJointNew2(tankControlBody, tankBody, cpvzero, cpvzero));
	cpConstraintSetMaxBias(pivot, 0); // disable joint correction
	cpConstraintSetMaxForce(pivot, 10000.0f); // emulate linear friction

	cpConstraint *gear = cpSpaceAddConstraint(space, cpGearJointNew(tankControlBody, tankBody, 0.0f, 1.0f));
	cpConstraintSetErrorBias(gear, 0); // attempt to fully correct the joint each step
	cpConstraintSetMaxBias(gear, 1.2f);  // but limit it's angular correction rate
	cpConstraintSetMaxForce(gear, 50000.0f); // emulate angular friction

	return space;
}

extern(C) {
    static void ConstraintFreeWrap(cpSpace *space, cpConstraint *constraint, void *unused){
        cpSpaceRemoveConstraint(space, constraint);
        cpConstraintFree(constraint);
    }

    static void PostConstraintFree(cpConstraint *constraint, cpSpace *space){
        cpSpaceAddPostStepCallback(space, cast(cpPostStepFunc)(&ConstraintFreeWrap), constraint, null);
    }

    static void BodyFreeWrap(cpSpace *space, cpBody *bod, void *unused){
        cpSpaceRemoveBody(space, bod);
        cpBodyFree(bod);
    }

    static void PostBodyFree(cpBody *bod, cpSpace *space){
        cpSpaceAddPostStepCallback(space, cast(cpPostStepFunc)(&BodyFreeWrap), bod, null);
    }

    static void ShapeFreeWrap(cpSpace *space, cpShape *shape, void *unused){
        cpSpaceRemoveShape(space, shape);
        cpShapeFree(shape);
    }

    static void PostShapeFree(cpShape *shape, cpSpace *space) {
        cpSpaceAddPostStepCallback(space, cast(cpPostStepFunc)(&ShapeFreeWrap), shape, null);
    }
}

static void
destroy(cpSpace *space)
{
	// Must remove these BEFORE freeing the body or you will access dangling pointers.
	cpSpaceEachShape(space, cast(cpSpaceShapeIteratorFunc)(&PostShapeFree), space);
	cpSpaceEachConstraint(space, cast(cpSpaceConstraintIteratorFunc)(&PostConstraintFree), space);

	cpSpaceEachBody(space, cast(cpSpaceBodyIteratorFunc)(&PostBodyFree), space);
	cpSpaceFree(space);
}

static void drawBody(cpBody *bod, float w, float h, ALLEGRO_COLOR c) {
    cpVect pos = cpBodyGetPosition(bod);
    cpFloat angle = cpBodyGetAngle(bod);

    ALLEGRO_TRANSFORM trans;
    al_identity_transform(&trans);
    al_translate_transform(&trans, -w / 2, -h / 2); // center
    al_rotate_transform(&trans, angle);
    al_translate_transform(&trans, pos.x, pos.y);
    al_use_transform(&trans);

    al_draw_filled_rectangle(0, 0, w, h, c);

    al_identity_transform(&trans);
    al_use_transform(&trans);
}

int main() {
    import std.stdio;

    ALLEGRO_DISPLAY     *display     = null;
    ALLEGRO_EVENT_QUEUE *event_queue = null;
    ALLEGRO_TIMER       *timer       = null;

    if(!al_init()) {
        stderr.writeln("failed to initialize allegro!\n");
        return -1;
    }

    al_init_primitives_addon();

    timer = al_create_timer(1.0 / 60);
    if(!timer) {
        stderr.writeln("failed to create timer!\n");
        return -1;
    }

    display = al_create_display(640, 480);
    if(!display) {
        stderr.writeln("failed to create display!\n");
        al_destroy_timer(timer);
        return -1;
    }

    event_queue = al_create_event_queue();
    if(!event_queue) {
        stderr.writeln("failed to create event_queue!\n");
        al_destroy_display(display);
        al_destroy_timer(timer);
        return -1;
    }

    al_register_event_source(event_queue, al_get_display_event_source(display));
    al_register_event_source(event_queue, al_get_timer_event_source(timer));

    al_start_timer(timer);

    cpSpace* space = init();
    cpBodySetPosition(tankBody, cpv(40, 40));

    bool redraw = true;
    while(1) {
        ALLEGRO_EVENT ev;
        al_wait_for_event(event_queue, &ev);

        if(ev.type == ALLEGRO_EVENT_TIMER) {
            redraw = true;
        }
        else if(ev.type == ALLEGRO_EVENT_DISPLAY_CLOSE) {
            break;
        }

        if(redraw && al_is_event_queue_empty(event_queue)) {
            update(space, 1.0 / 60.0);
            redraw = false;
            al_clear_to_color(al_map_rgb(0,0,0));

            for (int i = 0 ; i < 50 ; ++i)
                drawBody(boxes[i], 20, 20, al_map_rgb(0,128,0));

            drawBody(tankBody, 30, 30, al_map_rgb(128,0,0));

            al_flip_display();
        }
    }

    al_destroy_timer(timer);
    al_destroy_display(display);
    al_destroy_event_queue(event_queue);

    return 0;
}
