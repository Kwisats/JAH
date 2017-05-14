#define PERL_NO_GET_CONTEXT
#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"

#include "ppport.h"

#include "const-c.inc"

MODULE = Stats		PACKAGE = Stats		

INCLUDE: const-xs.inc

void 
hello()
	CODE:
		printf("Hello, world!\n");

int 
is_even(input)
		int input
	CODE:
		RETVAL = (input % 2 == 0);
	OUTPUT:
		RETVAL

void
round(arg)
		double arg
	CODE:
		if (arg > 0.0) {
			arg = floor(arg + 0.5);
		} else if (arg < 0.0) {
			arg = ceil(arg - 0.5);
		} else {
			arg = 0.0;
		}
	OUTPUT:
		arg

void
add (object, name, value)
		SV *object;
		char *name;
		double value;
	CODE:
		//check object
		if ( !(SvOK(object) && SvROK(object)) ) croak("not a reference or undefined object");
		SV *_self = SvRV(object);
		
		if ( SvTYPE(_self) != SVt_PVHV) croak("not a hashref object");
		
		HV *self = (HV*)_self;
		
		if ( !(hv_exists(self, "metrics", 7) && hv_exists(self)) ) croak("object doesn't contain some keys ('metrics' or/and 'code')");
		
		//fetch metrics and code
		SV **_metrics = hv_fetchs(self, "metrics", 0);
		SV **r__code = hv_fetchs(self, "code", 0);
		if( !(_metrics && r__code) ) croak("metrics and code can't be NULL");

		//check metrics
		SV *r_metrics = *_metrics;
		if ( !(SvOK(r_metrics) && SvROK(r_metrics)) ) croak("not a reference or undefined metrics");
		SV *__metrics = SvRV(r_metrics);
		if (SvTYPE(__metrics) != SVt_PVHV) croak("not a hashref metrics");
		HV *metrics = (HV*)__metrics;

		//check code
		SV *__code = *r__code;
		if ( !SvOK(__code) ) croak("not a reference config");
		SV *_code = SvRV(__code);
		if ( SvTYPE(_code) != SVt_PVCV) croak("not a coderef code");

		int old_cnt;
		double old_sum, new_sum, old_min, new_min, old_max, new_max, old_avg;

		if ( hv_exists(metrics, name, strlen(name)) ) {
			
		}


























