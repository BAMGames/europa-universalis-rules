var DBLCLICKTIME=500;
var LONGCLICKTIME=500;
var DRAGFUZZ=25;

if (jQuery) {(function($){
    $.extend($.fn,{
	multiClick: function(data,h) {
            var t,dbl,drg,dly,drl,dlc;
            // $._mc will store general data related to the
            // current ui action: timers, especially
            t=$._mc;
            dlc=(h.halfClick!==undefined||h.longClick!==undefined);
            dbl=(h.doubleClick!==undefined||h.halfClick!==undefined);
            drl=(h.longDragInit!==undefined||h.longDragStart!==undefined||
                 h.longDragStop!==undefined||h.longDragMove!==undefined);
            drg=(h.dragInit!==undefined||h.dragStart!==undefined||
                 h.dragStop!==undefined||h.dragMove!==undefined);
            dly=(drg||dbl||h.delayed!==undefined);
            if (!dbl && !drg && !drl && !h.simpleClick && ! h.longClick) {
                // purge
                t.cancel();
                $(this).each( function() {
                    $(this).unbind('._mcs');
                });
                return this;
            }
            // setup
            function fmd(e) {
                var t;
                e.preventDefault();
                t=$._mc;
                if (t.o) {
                    // mousedown, while mouseup not caught.
                    // Do nothing.
                    // This can happen with two-buttons mice
                    return;
                }
                e.pos=$._mc_touchXY(e);
                if (t.h === undefined) {                        
                    t.second=false;
                } else {
                    $._mc_cancel();
                    t=$._mc;
                    t.second=true;
                }
                t.o=true;
                t.h=h;
                t.dbl=dbl;
                t.drg=drg;
                t.drl=drl;
                t.dly=dly;
                t.dlc=dlc;
                t.md=e;
                if (dbl && !t.second) {
                    t.dct=setTimeout($._mc_exp_dct,DBLCLICKTIME);
                }
                if ((h.halfClick&&t.second)||(h.longClick&&!t.second)) {
                    t.lct=setTimeout($._mc_exp_lct,DBLCLICKTIME);
                }
                if (dlc || e.button!=2) {
                    $(window).bind('mouseup._mc touchend._mc',data,$._mc_fmu);
                }
                if (drg || drl) {
                    $(window).bind('mousemove._mc touchmove._mc',data,$._mc_fmm);
                }
                if (drg && h.dragInit) {
                    h.dragInit.call(this,e);
                }
            }
            $(this).each( function() {
                $(this).bind('mousedown._mcs touchstart._mcs',data,fmd);
	        $(this).get(0).oncontextmenu = function() {return false;};
            });
            return this;
        }
    });
    $._mc={};
    $._mc_exp_dct=function() {
        var t,e,c,h,r;
        t=$._mc;
        delete $._mc.dct;
        e=t.pending;
        if (e) {
            c=t.ctx;
            h=t.h;
            r=(t.lct===undefined && t.dlc);
            if (e.button === 2) {
		r=true;
            }
            if (h.simpleClick && !r) {
                h.simpleClick.call(c,e);
            } else if (h.longClick && r) {
                h.longClick.call(c,e);
            }
            $._mc_cancel();
        }
    };
    $._mc_exp_lct=function() {
        var t;
        t=$._mc;
        delete t.lct;
        if (!t.dly) {
            t.md.type='mouseup';
            t.md.timeStamp=$.now();
            $._mc_fmu.call($(window).get(0),t.md);
        }
        if (t.drl && t.h.longDragInit) {
            t.h.longDragInit.call($(window).get(0),t.md);
        }
    };
    $._mc_fmu=function(e) {
        var t,h,right;
        e.preventDefault();
        e.pos=$._mc_touchXY(e);
        t=$._mc;
        h=t.h;
        if (t.second) { // End of click
            right=(t.lct===undefined && t.dlc);
            if (e.button === 2) {
		right=true;
            }
            if (h.doubleClick && !right) {
                h.doubleClick.call(this,e);
            } else if (h.halfClick && right) {
                h.halfClick.call(this,e);
            }
            $._mc_cancel();
        } else if (!t.dbl || !t.dct) {
            right=(t.lct===undefined && t.dlc);
            if (e.button === 2) {
		right=true;
            }
            if (h.simpleClick && !right) {
                h.simpleClick.call(this,e);
            } else if (h.longClick && right) {
                h.longClick.call(this,e);
            }
            $._mc_cancel();
        } else {
            t.pending=e;
            t.ctx=this;
            t.o=false;
        }
    };
    $._mc_fmm=function(e) {
        var x,y,t,h,b;
        e.preventDefault();
        e.pos=$._mc_touchXY(e);
        t=$._mc;
        h=t.h;
        x=(t.md.pos[0]-e.pos[0]);
        y=(t.md.pos[1]-e.pos[1]);
        if (x*x+y*y>=DRAGFUZZ) {
            b=$(window);
            if (t.dct) {
                clearTimeout(t.dct);
            }
            if (t.lct) {
                t.longDrag=false;
                clearTimeout(t.lct);
            } else {
                t.longDrag=t.drl;
            }
            b.unbind('._mc').
                bind('mousemove._mc touchmove._mc',t.md.data,$._mc_dmm).
                bind('mouseup._mc touchend._mc',t.md.data,$._mc_dmu);
            if (h.longDragStart && t.longDrag) {
                h.longDragStart.call(t.md.currentTarget,t.md);
            }
            if (h.dragStart && !t.longDrag) {
                h.dragStart.call(t.md.currentTarget,t.md);
            }
            if (h.longDragMove && t.longDrag) {
                h.longDragMove.call(b.get(0),e);
            }
            if (h.dragMove && !t.longDrag) {
                h.dragMove.call(b.get(0),e);
            }
        }
    };
    $._mc_dmm=function(e) {
        var t,h;
        t=$._mc;
        h=t.h;
        e.preventDefault();
        e.pos=$._mc_touchXY(e);
        if (h.dragMove && !t.longDrag) {
            h.dragMove.call($(window).get(0),e);
        } else if (h.longDragMove && t.longDrag) {
            h.longDragMove.call($(window).get(0),e);
        }
    };
    $._mc_dmu=function(e) {
        var t,h;
        t=$._mc;
        h=t.h;
        e.preventDefault();
        e.pos=$._mc_touchXY(e);
        if (h.dragStop && !t.longDrag) {
            h.dragStop.call($(window).get(0),e);
        } else if (h.longDragStop && t.longDrag) {
            h.longDragStop.call($(window).get(0),e);
        }
        $._mc_cancel();
    };
    $._mc_cancel=function() {
        var t=$._mc;
        $(window).unbind('._mc');
        if (t.dct) {
            clearTimeout(t.dct);
        }
        if (t.lct) {
            clearTimeout(t.lct);
        }
        if (t.h.end) {
            t.h.end.call($(window),t.md);
        }
        $._mc={};
    };
    $._mc_touchXY=function(e) {
        var t;
        e.preventDefault();
        if (e.type.substr(0,5)==='touch') {
            t=e.originalEvent.changedTouches[0];
            return [t.pageX,t.pageY];
        } else {
            return [e.pageX,e.pageY];
        }
    };
}(jQuery));}
