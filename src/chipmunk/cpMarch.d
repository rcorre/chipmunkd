import core.stdc.config;

extern (C):

alias double function (cpVect, void*) cpMarchSampleFunc;
alias void function (cpVect, cpVect, void*) cpMarchSegmentFunc;

void cpMarchSoft (cpBB bb, c_ulong x_samples, c_ulong y_samples, cpFloat threshold, cpMarchSegmentFunc segment, void* segment_data, cpMarchSampleFunc sample, void* sample_data);
void cpMarchHard (cpBB bb, c_ulong x_samples, c_ulong y_samples, cpFloat threshold, cpMarchSegmentFunc segment, void* segment_data, cpMarchSampleFunc sample, void* sample_data);