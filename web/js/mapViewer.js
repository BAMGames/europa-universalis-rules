// mapViewer in JS using jQuery

// TODO
// pinch and zoom
// cache refactoring
// emptying cache
// merge tiles/images
// zoom and rotation ?
// Markers
// Shapes
// and that's all
var mV={}
mV.map=function(canvas,args) {
    var self=this
    var i
    var a=$.extend({},{
        center: new mV.point(0.5,0.5),
        minZoom: 0,
    },args)
    if (!a.url) throw('No URL scheme')
    if (!a.blankUrl) throw('No blank URL scheme')
    var ce=$('#'+canvas).empty().attr('tabindex',0)
    ce[0].focus()
    ce.css('overflow','hidden')
    var c=$('<div>').css({
        position:'relative',
        overflow:'hidden',
        height:'100%',
        width:'100%',
        backgroundColor:'#C0C0C0',
    }).appendTo(ce)
    ce.multiClick(undefined,{
        doubleClick: function(e) {self._movezoom(e,1)},
        longClick: function(e) {self._movezoom(e,-1)},
        halfClick: function(e) {self._movezoom(e,-1)},
        dragInit: function(e) {self.ce[0].focus()},
        dragStart: function(e) {self._movestart.apply(self,[e])},
        dragMove: function(e) {self._movemove.apply(self,[e])},
        dragStop: function(e) {self._movestop.apply(self,[e])},
    }).mousewheel(function(e,delta,deltax,deltay) {self._movezoom(e,delta)}).
        resize(function() {self.__update();self._update()}).
        keypress(function(e) {self._keypress.apply(self,[e])}).
        keydown(function(e) {self._keydown.apply(self,[e])})
    this.plane=new Array();
    for (i=a.minZoom;i<=a.maxZoom;i++) {
        this.plane[i]=$('<div>').css({
            position:'absolute',
            top:0,
            left:0,
            WebkitTransformOrigin: '50% 50%',
            transformOrigin: '50% 50%',
            width: '100%',
            height: '100%',
            zIndex: 1+i,
        }).attr('id','plane'+i).appendTo(c)
    }
    this.c=c
    this.ce=ce
    this.a=a
    this.z=a.minZoom
    this.pz=0
    this.center=a.center
    delete a.center
    this.canvasName=canvas
    this.tiles={}
    this.g={}
    this.h={}
    this.h.s={}
    this.h.h={}
    this.h.clean={}
    this.h.visible={}
    this.h.cleaner=0
    this.h.count=0
    this.h.pending=0
    this.moving={}
    this.__update()
    this._update()
    return this
}
mV.map.prototype.__update=function() {
    var a=this.c.offset()
    var b=this.c.height()
    var c=this.c.width()
    this.cx=a.top+c/2
    this.cy=a.left+b/2
}
mV.map.prototype.pointToScreen=function(p) {
    var a=(1+this.pz/100)*(1<<(this.z+8)) // 8 is related to tile size
    return [(p.x-this.center.x)*a+this.cx,(this.center.y-p.y)*a+this.cy]
}
mV.map.prototype.screenToPoint=function(p) {
    var a=(1+this.pz/100)*(1<<(this.z+8)) // 8 is related to tile size
    return {x:(p[0]-this.cx)/a+this.center.x,y:(p[1]-this.cy)/(-a)+this.center.y}
}
mV.map.prototype._movezoom=function(e,zz) {
    var z=zz+this.z
    if (z>this.a.maxZoom) return
    if (z<0) return
    var a=1<<(this.z+8) // 8 is related to tile size
    var w=this.c.width()/2
    var o=this.c.offset()
    var h=this.c.height()/2
    if (!e.pos) e.pos=$._mc_touchXY(e);
    var x=(e.pos[0]-w-o.left)
    var y=(e.pos[1]-h-o.top)
    if (zz==1) {
        x=x/2
        y=y/2
    } else if (zz=-1) {
        x=-x
        y=-y
    }
    this.center.x+=x/a
    this.center.y-=y/a
    this.z=z
    this._update()
}
mV.map.prototype._movestart=function(e) {
    this.moving.refPoint=e.pos
    this.moving.centerX=this.center.x
    this.moving.centerY=this.center.y
    this.moving.windowX=$(window).width()
    this.moving.windowY=$(window).height()
}
mV.map.prototype._keydown=function(e) {
    var a=1<<(this.z+8) // 8 is related to tile size
    var dy=0,dx=0
    switch(e.which) {
    case 37:
        dx=-10;break
    case 38:
        dy=10;break
    case 39:
        dx=10;break
    case 40:
        dy=-10;break
    }
    this.center.y-=dy/a
    this.center.x-=dx/a
    this._update()
}
mV.map.prototype._keypress=function(e) {
    switch(e.which) {
    case 43:
    case 45:
        var w=this.c.width()/2
        var o=this.c.offset()
        var h=this.c.height()/2
        e.pos=[w+o.left,h+o.top]
        this._movezoom(e,(e.which===43)?1:-1);break
    default:
        console.log(e.which)
    }
}
mV.map.prototype._movemove=function(e) {
    var a=1<<(this.z+8) // 8 is related to tile size
    var d
    var out=false
    var self=this
    window.clearTimeout(this.moving.timeout)
    if (e.pos[1]<0) {
        d=-Math.ceil(e.pos[1]/5)/a
        this.moving.centerY=this.moving.centerY-d
        this.center.y-=d
        out=true
    } else if (e.pos[1]>this.moving.windowY) {
        d=-(Math.ceil((e.pos[1]-this.moving.windowY)/5))/a
        this.moving.centerY=this.moving.centerY-d
        this.center.y-=d
        out=true
    } else {
        d=-(e.pos[1]-this.moving.refPoint[1])/a
        this.center.y=this.moving.centerY-d
    }
    if (e.pos[0]<0) {
        d=Math.ceil(e.pos[0]/5)/a
        this.moving.centerX=this.moving.centerX-d
        this.center.x-=d
        out=true
    } else if (e.pos[0]>this.moving.windowX) {
        d=(Math.ceil((e.pos[0]-this.moving.windowX)/5))/a
        this.moving.centerX=this.moving.centerX-d
        this.center.x-=d
        out=true
    } else {
        d=(e.pos[0]-this.moving.refPoint[0])/a
        this.center.x=this.moving.centerX-d
    }
    this._update()
    if (out) {
        this.moving.timeout=window.setTimeout(function(){self._movemove(e)},10)
    }
}
mV.map.prototype._movestop=function(e) {
    window.clearTimeout(this.moving.timeout)
    this.moving={}
}
mV.map.prototype._update=function() {
    var w=this.c.width()/2
    var h=this.c.height()/2
    if (this.pz) {
        this.plane[this.z].css({
            'WebkitTransform':'scale('+Math.floor(100+this.pz)/100+')',
            'opacity':'0.'+(100-this.pz)
        })
        this.plane[(this.z)+1].css({
            'WebkitTransform':'scale('+Math.floor(100+this.pz)/200+')',
            'opacity':'0.'+(this.pz)
        })
    } else {
        this.plane[this.z].css('WebkitTransform','')
    }
    var a,ox,oy,iswx,iswy,inex,iney,i,v,x,y,z,d,zs,zss
    zs=this.z
    zss=zs+(this.pz?1:0)
    for (z=zs;z<=zss;z++) {
        a=1<<(z+8) // 8 is related to tile size
        ox=w-this.center.x*a
        oy=this.center.y*a+h-256 // 256 is related to tile size
        iswx=Math.floor((this.center.x*a-w)/256) // 256 is related to tile size
        iswy=Math.floor((this.center.y*a-h)/256) // 256 is related to tile size
        inex=Math.floor((this.center.x*a+w)/256) // 256 is related to tile size
        iney=Math.floor((this.center.y*a+h)/256) // 256 is related to tile size
        for (var i in this.tiles) {
            if (this.tiles.hasOwnProperty(i)) {
                v=this.tiles[i]
                if (v.z<zs||v.z>zss||v.x<iswx||v.x>inex||v.y<iswy||v.y>iney)
                    this._undisplayTile(i,v)
            }
        }
        for (x=iswx;x<=inex;x++)
            for (y=iswy;y<=iney;y++) {
                if (!this.tiles[z+'_'+x+'_'+y]) this._displayTile(z,x,y)
            }
        
        for (x=iswx;x<=inex;x++)
            for (y=iswy;y<=iney;y++) {
                d=this.tiles[z+'_'+x+'_'+y].d
                d.css({top:oy-256*y,left:ox+256*x}) // 256 related to tile size
            }
    }
}
mV.map.prototype._undisplayTile=function(i,v) {
    $('#tile_'+i).remove()
    delete this.tiles[i]
}
mV.map.prototype._displayTile=function(z,x,y) { 
    var s=z+'_'+x+'_'+y
    var dd=(new Date).getTime()
    var d=$('<div>').attr('id','tile_'+s).css({
        '-webkit-user-select':'none',
        position:'absolute',
        left:-10000,
        top:-10000,
        width: 256, // 256 is related to tile size
        height: 256, // 256 is related to tile size
        zIndex: 1+z,
    }).appendTo(this.plane[z])
    var self=this
    var a=1<<z
    var u
    var res={x:x,y:y,z:z,d:d}
    this.tiles[s]=res
    if (x<0 || x>=a || y<0 ||y>=a) {
        $('<img>').attr({
            src: this.a.blankUrl,
            alt: 'blank'
        }).appendTo(d)
        return
    }
    var u=this.a.url+z+'/'+x+'_'+y+'.png'
    res.u=u
    if (this.h.s[s]>1) {
        d.empty().append(this.h.h[s])
        this.h.visible[s]=true
        return
    }
    var k=$('<div>loading</div>').css({
        width:254,height:254,
        border:'1px solid black',
        top:0,left:0,position:'absolute'
    }).appendTo(d)
    this.h.s[s]=1
    if (!this.h.cleaner) {
        this.h.cleaner=window.setInterval(function() {
            self.cleanCache.apply(self,[])
        },5000)
    }
    this.h.clean[s]=dd
    this.h.pending++
    this.h.h[s]=k
    var i=$('<img>').hide().load(function() {
        delete self.h.clean[s]
        self.h.s[s]=4
        self.h.pending--
        self.h.count++
        self.h.h[s]=$('<img>').attr('src',u)
        d.hide().empty().append(self.h.h[s]).fadeIn()
    }).error(function() {
        delete self.h.clean[s]
        self.h.s[s]=3
        self.h.pending--
        self.h.h[s].empty().append('No tile available')
    }).appendTo(k)
    k.appendTo(d)
//    window.setTimeout(function() {i.attr('src',u)},1000+3000*Math.random())
    i.attr('src',u)
    return res
}
mV.map.prototype.setGoal=function(g) {
    // center: target center
    // zoom: target zoom
    // poi: point of interest (invariant by zooming)
    var self=this
    this.g.oldcenter=this.center
    if (g.center!==undefined) {
        this.g.center=g.center
        delete this.g.poi
    }
    this.g.oldz=100*this.z+this.pz
    if (g.zoom!==undefined) {
        this.g.zoom=g.zoom
    }
    if (g.poi!==undefined) {
        this.g.poi=g.poi
        delete this.g.center
    }
    this.g.max=10
    this.g.step=0
    if (!this.g.interval) {
        this.g.interval=window.setInterval(function() {self.achieveGoal()},1000)
    }
}
mV.map.prototype.achieveGoal=function() {
    var cz
    var g=this.g
    g.step+=1
    if (g.zoom!==undefined) {
        cz=Math.round((100*g.zoom-g.oldz)*(g.step/g.max)+g.oldz)
        this.pz=cz%100
        this.z=Math.round((cz-cz%100)/100)
    }
    if (g.center!==undefined) { 
        this.center=new mV.point(
            g.step/g.max*(g.center.x-g.oldcenter.x)+g.oldcenter.x,
            g.step/g.max*(g.center.y-g.oldcenter.y)+g.oldcenter.y
        )
    }
    if (g.poi!==undefined) {
        // TODO: deal with POI
        true
    }
    this._update()
    if (g.step>=g.max) {
        // No more goals
        window.clearInterval(this.g.interval)
        this.g={}
        this.g.step=0
    }
}
mV.map.prototype.cleanCache=function() {
    var d=(new Date).getTime()
    for (var s in this.h.clean) {
        if (this.h.clean[s]+5<=d) {
            delete this.h.clean[s]
            delete this.h.h[s]
            delete this.h.s[s]
            this.h.pending--
        }
    }
    if (this.h.pending==0) {
        window.clearInterval(this.h.cleaner)
        delete this.h.cleaner
    }
}
mV.map.prototype.setZoom=function(z) {
    if (z<0) z=0
    if (z>this.a.maxZoom) z=this.a.maxZoom
    if (this.z==z) return
    this.z=z
    this._update()
}
mV.map.prototype.moveCenter=function(x,y) {
    var a=1<<(this.z+8) // 8 is related to tile size 
    this.center.x+=x/a
    this.center.y+=y/a
    this._update()
}
mV.map.prototype.setCenter=function(c) {
    this.center=c
    this._update()
}
mV.map.prototype.getZoom=function() {
    return this.z
}
mV.point=function(x,y) {
    var point={}
    this.x=x
    this.y=y
}
mV.point.prototype.coordinates=function(m) {
    var a=1<<(m.a.maxZoom+8) // 8 is related to tile size
    return [this.x*a,this.y*a]
}