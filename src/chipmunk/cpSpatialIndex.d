module chipmunk.cpSpatialIndex;
import core.stdc.config;

extern (C):

alias cpBB function (void*) cpSpatialIndexBBFunc;
alias void function (void*, void*) cpSpatialIndexIteratorFunc;
alias uint function (void*, void*, uint, void*) cpSpatialIndexQueryFunc;
alias double function (void*, void*, void*) cpSpatialIndexSegmentQueryFunc;
alias cpSpatialIndexClass cpSpatialIndexClass;
alias cpSpatialIndex cpSpatialIndex;
alias cpSpaceHash cpSpaceHash;
alias cpBBTree cpBBTree;
alias cpVect function (void*) cpBBTreeVelocityFunc;
alias cpSweep1D cpSweep1D;
alias void function (cpSpatialIndex*) cpSpatialIndexDestroyImpl;
alias int function (cpSpatialIndex*) cpSpatialIndexCountImpl;
alias void function (cpSpatialIndex*, void function (void*, void*), void*) cpSpatialIndexEachImpl;
alias ubyte function (cpSpatialIndex*, void*, c_ulong) cpSpatialIndexContainsImpl;
alias void function (cpSpatialIndex*, void*, c_ulong) cpSpatialIndexInsertImpl;
alias void function (cpSpatialIndex*, void*, c_ulong) cpSpatialIndexRemoveImpl;
alias void function (cpSpatialIndex*) cpSpatialIndexReindexImpl;
alias void function (cpSpatialIndex*, void*, c_ulong) cpSpatialIndexReindexObjectImpl;
alias void function (cpSpatialIndex*, uint function (void*, void*, uint, void*), void*) cpSpatialIndexReindexQueryImpl;
alias void function (cpSpatialIndex*, void*, cpBB, uint function (void*, void*, uint, void*), void*) cpSpatialIndexQueryImpl;
alias void function (cpSpatialIndex*, void*, cpVect, cpVect, double, double function (void*, void*, void*), void*) cpSpatialIndexSegmentQueryImpl;

struct cpSpatialIndex
{
    cpSpatialIndexClass* klass;
    cpSpatialIndexBBFunc bbfunc;
    cpSpatialIndex* staticIndex;
    cpSpatialIndex* dynamicIndex;
}

struct cpSpatialIndexClass
{
    cpSpatialIndexDestroyImpl destroy;
    cpSpatialIndexCountImpl count;
    cpSpatialIndexEachImpl each;
    cpSpatialIndexContainsImpl contains;
    cpSpatialIndexInsertImpl insert;
    cpSpatialIndexRemoveImpl remove;
    cpSpatialIndexReindexImpl reindex;
    cpSpatialIndexReindexObjectImpl reindexObject;
    cpSpatialIndexReindexQueryImpl reindexQuery;
    cpSpatialIndexQueryImpl query;
    cpSpatialIndexSegmentQueryImpl segmentQuery;
}

struct cpBBTree;


struct cpSweep1D;


struct cpSpaceHash;


cpSpaceHash* cpSpaceHashAlloc ();
cpSpatialIndex* cpSpaceHashInit (cpSpaceHash* hash, cpFloat celldim, int numcells, cpSpatialIndexBBFunc bbfunc, cpSpatialIndex* staticIndex);
cpSpatialIndex* cpSpaceHashNew (cpFloat celldim, int cells, cpSpatialIndexBBFunc bbfunc, cpSpatialIndex* staticIndex);
void cpSpaceHashResize (cpSpaceHash* hash, cpFloat celldim, int numcells);
cpBBTree* cpBBTreeAlloc ();
cpSpatialIndex* cpBBTreeInit (cpBBTree* tree, cpSpatialIndexBBFunc bbfunc, cpSpatialIndex* staticIndex);
cpSpatialIndex* cpBBTreeNew (cpSpatialIndexBBFunc bbfunc, cpSpatialIndex* staticIndex);
void cpBBTreeOptimize (cpSpatialIndex* index);
void cpBBTreeSetVelocityFunc (cpSpatialIndex* index, cpBBTreeVelocityFunc func);
cpSweep1D* cpSweep1DAlloc ();
cpSpatialIndex* cpSweep1DInit (cpSweep1D* sweep, cpSpatialIndexBBFunc bbfunc, cpSpatialIndex* staticIndex);
cpSpatialIndex* cpSweep1DNew (cpSpatialIndexBBFunc bbfunc, cpSpatialIndex* staticIndex);
void cpSpatialIndexFree (cpSpatialIndex* index);
void cpSpatialIndexCollideStatic (cpSpatialIndex* dynamicIndex, cpSpatialIndex* staticIndex, cpSpatialIndexQueryFunc func, void* data);
void cpSpatialIndexDestroy (cpSpatialIndex* index);
int cpSpatialIndexCount (cpSpatialIndex* index);
void cpSpatialIndexEach (cpSpatialIndex* index, cpSpatialIndexIteratorFunc func, void* data);
cpBool cpSpatialIndexContains (cpSpatialIndex* index, void* obj, cpHashValue hashid);
void cpSpatialIndexInsert (cpSpatialIndex* index, void* obj, cpHashValue hashid);
void cpSpatialIndexRemove (cpSpatialIndex* index, void* obj, cpHashValue hashid);
void cpSpatialIndexReindex (cpSpatialIndex* index);
void cpSpatialIndexReindexObject (cpSpatialIndex* index, void* obj, cpHashValue hashid);
void cpSpatialIndexQuery (cpSpatialIndex* index, void* obj, cpBB bb, cpSpatialIndexQueryFunc func, void* data);
void cpSpatialIndexSegmentQuery (cpSpatialIndex* index, void* obj, cpVect a, cpVect b, cpFloat t_exit, cpSpatialIndexSegmentQueryFunc func, void* data);
void cpSpatialIndexReindexQuery (cpSpatialIndex* index, cpSpatialIndexQueryFunc func, void* data);