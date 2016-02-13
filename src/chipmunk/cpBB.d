module chipmunk.cpBB;
extern (C):

alias cpBB cpBB;

struct cpBB
{
    cpFloat l;
    cpFloat b;
    cpFloat r;
    cpFloat t;
}

cpBB cpBBNew (const cpFloat l, const cpFloat b, const cpFloat r, const cpFloat t);
cpBB cpBBNewForExtents (const cpVect c, const cpFloat hw, const cpFloat hh);
cpBB cpBBNewForCircle (const cpVect p, const cpFloat r);
cpBool cpBBIntersects (const cpBB a, const cpBB b);
cpBool cpBBContainsBB (const cpBB bb, const cpBB other);
cpBool cpBBContainsVect (const cpBB bb, const cpVect v);
cpBB cpBBMerge (const cpBB a, const cpBB b);
cpBB cpBBExpand (const cpBB bb, const cpVect v);
cpVect cpBBCenter (cpBB bb);
cpFloat cpBBArea (cpBB bb);
cpFloat cpBBMergedArea (cpBB a, cpBB b);
cpFloat cpBBSegmentQuery (cpBB bb, cpVect a, cpVect b);
cpBool cpBBIntersectsSegment (cpBB bb, cpVect a, cpVect b);
cpVect cpBBClampVect (const cpBB bb, const cpVect v);
cpVect cpBBWrapVect (const cpBB bb, const cpVect v);
cpBB cpBBOffset (const cpBB bb, const cpVect v);