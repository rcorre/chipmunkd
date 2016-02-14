module chipmunk.chipmunk_types;

import core.stdc.config;
import core.stdc.math;
import core.stdc.float_;

extern (C):

enum CP_NO_GROUP = 0;

// TODO: support CP_USE_DOUBLES? Right now I just assume we're using doubles.

alias cpFloat = double;
alias cpfsqrt = sqrt;
alias cpfsin = sin;
alias cpfcos = cos;
alias cpfacos = acos;
alias cpfatan2 = atan2;
alias cpfmod = fmod;
alias cpfexp = exp;
alias cpfpow = pow;
alias cpffloor = floor;
alias cpfceil = ceil;
enum CPFLOAT_MIN = DBL_MIN;

alias c_ulong cpHashValue;
alias uint cpCollisionID;
alias ubyte cpBool;
alias void* cpDataPointer;
alias c_ulong cpCollisionType;
alias c_ulong cpGroup;
alias uint cpBitmask;
alias uint cpTimestamp;

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
