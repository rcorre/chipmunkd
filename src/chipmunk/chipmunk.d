extern (C):

alias cpArray cpArray;
alias cpHashSet cpHashSet;
alias cpBody cpBody;
alias cpShape cpShape;
alias cpCircleShape cpCircleShape;
alias cpSegmentShape cpSegmentShape;
alias cpPolyShape cpPolyShape;
alias cpConstraint cpConstraint;
alias cpPinJoint cpPinJoint;
alias cpSlideJoint cpSlideJoint;
alias cpPivotJoint cpPivotJoint;
alias cpGrooveJoint cpGrooveJoint;
alias cpDampedSpring cpDampedSpring;
alias cpDampedRotarySpring cpDampedRotarySpring;
alias cpRotaryLimitJoint cpRotaryLimitJoint;
alias cpRatchetJoint cpRatchetJoint;
alias cpGearJoint cpGearJoint;
alias cpSimpleMotorJoint cpSimpleMotorJoint;
alias cpCollisionHandler cpCollisionHandler;
alias cpContactPointSet cpContactPointSet;
alias cpArbiter cpArbiter;
alias cpSpace cpSpace;

extern __gshared const(char)* cpVersionString;

struct cpRotaryLimitJoint;


struct cpSlideJoint;


struct cpRatchetJoint;


struct cpGearJoint;


struct cpSimpleMotorJoint;


struct cpArray;


struct cpDampedRotarySpring;


struct cpCircleShape;


struct cpHashSet;


struct cpConstraint;


struct cpPivotJoint;


struct cpContactPointSet;


struct cpGrooveJoint;


struct cpSpace;


struct cpArbiter;


struct cpCollisionHandler;


struct cpBody;


struct cpPolyShape;


struct cpDampedSpring;


struct cpShape;


struct cpSegmentShape;


struct cpPinJoint;


void cpMessage (const(char)* condition, const(char)* file, int line, int isError, int isHardError, const(char)* message, ...);
cpFloat cpMomentForCircle (cpFloat m, cpFloat r1, cpFloat r2, cpVect offset);
cpFloat cpAreaForCircle (cpFloat r1, cpFloat r2);
cpFloat cpMomentForSegment (cpFloat m, cpVect a, cpVect b, cpFloat radius);
cpFloat cpAreaForSegment (cpVect a, cpVect b, cpFloat radius);
cpFloat cpMomentForPoly (cpFloat m, int count, const(cpVect)* verts, cpVect offset, cpFloat radius);
cpFloat cpAreaForPoly (const int count, const(cpVect)* verts, cpFloat radius);
cpVect cpCentroidForPoly (const int count, const(cpVect)* verts);
cpFloat cpMomentForBox (cpFloat m, cpFloat width, cpFloat height);
cpFloat cpMomentForBox2 (cpFloat m, cpBB box);
int cpConvexHull (int count, const(cpVect)* verts, cpVect* result, int* first, cpFloat tol);
cpVect cpClosetPointOnSegment (const cpVect p, const cpVect a, const cpVect b);