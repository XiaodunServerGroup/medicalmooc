"""
Views for returning XModule JS (used by requirejs)
"""
from django.http import HttpResponse

def _is_super():
    def _dec(view_func):
        def check_perm(request, *args, **kwargs):
            user = request.user
            if user and request.user.is_staff:
                return view_func(request, *args, **kwargs)
            else:
                return HttpResponse('no perm...')
                #return HttpResponseRedirect()
        return check_perm
    return _dec

is_super = _is_super()    