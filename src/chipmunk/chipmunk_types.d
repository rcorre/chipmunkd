module chipmunk.chipmunk_types;
import core.stdc.config;

extern (C):

alias double cpFloat;
alias c_ulong cpHashValue;
alias uint cpCollisionID;
alias ubyte cpBool;
alias void* cpDataPointer;
alias c_ulong cpCollisionType;
alias c_ulong cpGroup;
alias uint cpBitmask;
alias uint cpTimestamp;
alias cpVect cpVect;
alias cpTransform cpTransform;
alias cpMat2x2 cpMat2x2;

struct cpVect
{
    cpFloat x;
    cpFloat y;
}

struct cpTransform
{
    cpFloat a;
    cpFloat b;
    cpFloat c;
    cpFloat d;
    cpFloat tx;
    cpFloat ty;
}

struct cpMat2x2
{
    cpFloat a;
    cpFloat b;
    cpFloat c;
    cpFloat d;
}

cpFloat cpfmax (cpFloat a, cpFloat b);
cpFloat cpfmin (cpFloat a, cpFloat b);
cpFloat cpfabs (cpFloat f);
cpFloat cpfclamp (cpFloat f, cpFloat min, cpFloat max);
cpFloat cpfclamp01 (cpFloat f);
cpFloat cpflerp (cpFloat f1, cpFloat f2, cpFloat t);
cpFloat cpflerpconst (cpFloat f1, cpFloat f2, cpFloat d);