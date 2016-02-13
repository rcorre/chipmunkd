module chipmunk.cpSimpleMotor;
extern (C):

alias cpSimpleMotor cpSimpleMotor;
alias cpSimpleMotor cpSimpleMotor;

struct cpSimpleMotor;


cpBool cpConstraintIsSimpleMotor (const(cpConstraint)* constraint);
cpSimpleMotor* cpSimpleMotorAlloc ();
cpSimpleMotor* cpSimpleMotorInit (cpSimpleMotor* joint, cpBody* a, cpBody* b, cpFloat rate);
cpConstraint* cpSimpleMotorNew (cpBody* a, cpBody* b, cpFloat rate);
cpFloat cpSimpleMotorGetRate (const(cpConstraint)* constraint);
void cpSimpleMotorSetRate (cpConstraint* constraint, cpFloat rate);
cpBool cpConstraintIsSimpleMotor (const(cpConstraint)* constraint);
cpSimpleMotor* cpSimpleMotorAlloc ();
cpSimpleMotor* cpSimpleMotorInit (cpSimpleMotor* joint, cpBody* a, cpBody* b, cpFloat rate);
cpConstraint* cpSimpleMotorNew (cpBody* a, cpBody* b, cpFloat rate);
cpFloat cpSimpleMotorGetRate (const(cpConstraint)* constraint);
void cpSimpleMotorSetRate (cpConstraint* constraint, cpFloat rate);