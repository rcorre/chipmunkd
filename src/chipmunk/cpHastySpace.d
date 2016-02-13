import core.stdc.config;

extern (C):

alias cpHastySpace cpHastySpace;

struct cpHastySpace;


cpSpace* cpHastySpaceNew ();
void cpHastySpaceFree (cpSpace* space);
void cpHastySpaceSetThreads (cpSpace* space, c_ulong threads);
c_ulong cpHastySpaceGetThreads (cpSpace* space);
void cpHastySpaceStep (cpSpace* space, cpFloat dt);