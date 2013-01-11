// Javascript for the board simulator

// BUG
// If one clicks on a window being closed, it tries to reclose it.
// The bindings of closing windows should be removed.
//
// The number of convoys allowed is always 5 for convoys, should vary

// ENHANCE
// update activity somehow for picker and stackzoom

// Assertions and debugging
// {{{

function AssertException(message) { this.message = message; }
AssertException.prototype.toString = function () {
    return 'AssertException: ' + this.message
}
function assert(exp, message) {
    if (!exp) {
        throw new AssertException(message)
    }
}

// function remap() {
//     $.getScript('http://localhost/eu/web/js/map.js')
// }
// var xlogwindow
// $(function() {
//     xlogwindow=$('<div />').css({
//         position:'absolute',
//         bottom:0,
//         right:0,
//         width: 100,
//         height:100,
//         lineHeight:1,
//         fontSize:8,
//         backgroundColor:'white',
//     }).attr('id','log').click(function() {xlogwindow.empty()}).appendTo($('body'))
// })
// function xlog(t) {
//     xlogwindow.append(t+'<br/>')
// }


// }}}

// Define constants
// {{{

var BASE="http://www-lipn.univ-paris13.fr/~dubacq/europa/"
var XBASE=BASE+"carte/"
var PBASE=BASE+"pions/"
// The following line is for local use. Do not use it on the remote server.
// It uses bitmaps in local directories
if (location.href.indexOf("file:///") != -1) {
    XBASE="../carte/bitmap/"
    PBASE="../pions/bitmap/"
}
if (location.href.indexOf("http://localhost") != -1) {
    XBASE="../carte/bitmap/"
    PBASE="../pions/bitmap/"
}
TILESIZE=256
// We add a constant to the "zoom" so that the map is actually pushed in a
// very small region of lat/lng (this avoids wraparound problems)
ZOOMOFFSET=4
// Zoom reference: this is our max zoom level, in which lat*MAGFACTOR will be
// 1 pixel
ZOOMREF=8
// Magfactor (conversion degrees*Magfactor=pixels of zoom lv ZOOMREF for us)
MAGFACTOR=1<<(ZOOMREF+ZOOMOFFSET)

// ZOOMMARKER: below this, no markers on map (unless markers magnified)
ZOOMMARKER=2
// sizes of counters at zoom ZOOMMARKERSIZEREF
ZOOMMARKERSIZEREF=8
STACKMARKERSIZES=[440,550]
MARKERSIZES=[400,500]
// Names of sides
COUNTERSIDES=[[''],['_recto','_verso']]
// Sizes in cells:
CELLSIZES=[80,50,63,63]
// Layers
CELLLAYERS={
    vet: [['vet',0,4,0,17,'Veteran'],['vetm',0,2,0,17]],
    nwd: [['fleet',0,21,0,17,'Warships'],['fleet',0,9,0,17]],
    ntd: [['fleettr',0,2,0,17,'Transports'],['fleettr',0,1,0,17]],
    ntdc: [['fleettrc',0,5,0,17,'Transports'],['fleettrc',0,2,0,17]],
    ngd: [['fleetga',0,14,2,13,'Galleys'],['fleetga',0,6,2,13]],
    nvgd: [['fleetgav',0,2,2,13,'Galleasses'],['fleetgav',0,2,2,13]],
    // Still TODO
    // nvet (=nwd veterans)
    // vetd (=veteran for detachment)
    // cfl (colony levels)
    // tfl (trade fleet levels)
}
LAYERSIZES={
    'fleet':[0,9,9,9,19,19,19,29,29,29,39,39,39,49,49,49,59,59,59,69,69,69],
    'fleettr':[0,10,10],
    'vet':[64,64,64,64],
    'vetm':[32,32],
    'fleettrc':[0,10,21,32,43,54],
    'fleetga':[0,9,9,19,19,29,29,39,39,49,49,59,59,69,69],
    'fleetgav':[0,9,19]
}
// Marker magnification
MARKERDELTA=0
// Timer for animations (milliseconds)
ANIMATIONTIME=400

// Types of windows
MAINMENUTYPE=0
STACKZOOMTYPE=1
PICKERTYPE=2
LOCATIONTYPE=3
SEARCHTYPE=4
ZOOMTYPE=5
MSGTYPE=6
HELPTYPE=7
PLAYERSTYPE=8

// This is the number of rounds before a window is autoclosed
ROUNDTIME=5000
LONGTIME=500

PLAYERS=[
    ['Neutral observer','menu/menu_Neutral','Observer'],
    ['Kingdom of France','menu/menu_Francia','France'],
    ['Kingdom of Spain','menu/menu_Hispania','Spain'],
    ['United provinces of Netherlands','menu/menu_Hollandia','Holland'],
    ['Ottoman Sultanate','menu/menu_Turcia','Turkey'],
    ['Kingdom of Great-Britain','menu/menu_Anglia','England'],
    ['Duchy of Austria and Habsburg Empire','menu/menu_Habsburgum','Austria'],
    ['Kingdom of Portugal','menu/menu_Portugallia','Portugal'],
    ['Kingdom of Poland','menu/menu_Polonia','Poland'],
    ['Kingdom of Sweden','menu/menu_Suecia','Sweden'],
    ['Republic of Venice','menu/menu_Venetia','Venice'],
    ['Kingdom of Prussia','menu/menu_Prussia','Prussia'],
    ['Tsardom of Russia','menu/menu_Russia','Russia'],
    ['Kingdom of Denmark','menu/menu_Dania','Denmark'],
    ['Holy See','menu/menu_SanctaSedes','Holy See'],
    ['Sultanate of Cairo','menu/menu_Ægyptus','Mamaluks'],
]
CURRENTPLAYER=0

// }}}

// Events settings (prevent text selection/image dragging)
// {{{

body=$('body')
jwindow=$(window)

context={}
context.normal=function() {    
    body.unbind()
    jwindow.unbind()
    $(document).unbind()
    $(document).bind("dragstart", function() {
        return false
    }).bind("mousedown", function() {
        return false
    })
    jwindow.bind('mousemove',function(e) {
        contours.updateCoordinates(e)
    })
    jwindow.bind('resize',function() {
        windowheight=jwindow.height()
        windowwidth=jwindow.width()
    })
    context.context=0
}
context.dragDrop=function() {
    context.context=1
}

// }}}

// server
// {{{

fakeServer=function() {
    this.i=300
    this.cronjob=setInterval(this.cron,ROUNDTIME)
}

fakeServer.prototype.getId=function(f) {
    var t=this
    setTimeout(function() {
        t.uid='i'+Math.floor(Math.random()*1000);f()
    },this.i)
}
fakeServer.prototype.sendOrder=function(o) {
    // fake send: just queue it
    o.x=true
    var t=this
    setTimeout(function() {t.receiveOrder(o);},LONGTIME)
}
fakeServer.prototype.receiveOrder=function(o) {
    o.x=1
    ordermanager.queue(o)
}
fakeServer.prototype.cron=function() {
    if (context.context==0) {
        windowmanager.deathRow()
        windowmanagermenu.deathRow()
    }
}

function cloneCounter(a) {
    return $.extend(true,{},{
        b:a.b, // size
        f:a.f, // filename
        i:a.i, // infinite
        a:a.a, // values
        k:a.k.slice(), // array: nicks[sides]
        p:a.p.slice(), // array: path
    })
}

function cloneCounters(c) {
    var k=[]
    for (var i in c) {
        k[i]=cloneCounter(c[i])
        for (var j in k[i].a) {
            if (k[i].a[j].n===undefined)
                k[i].a[j].n=0
            if (k[i].a[j].c===undefined)
                k[i].a[j].c=0
        }
    }
    return k
}

var windowheight
var windowwidth
var counters
var stacks
var map_hooks=[]
var map
var projection
var windowmanager
var windowmanagermenu
var origin
var SIZESCACHE=[]
pointzero=new google.maps.Point(0,0)

fakeServer.prototype.gameReboot=function() {
    // Called out of context
    // Reboots the whole game
    // Todo: pass stacks and counters
    context.normal()
    clearInterval(this.cronjob)
    windowheight=$(window).height()
    windowwidth=$(window).width()
    // Empties everything back to the standard
    if (windowmanager) {
        windowmanager.destroy()
    }
    if (windowmanagermenu) {
        windowmanagermenu.destroy()
    }
    if (stacks) {
        stacks.destroy()
    }
    if (counters) {
        counters.destroy()
    }
    mainmenu=new mainMenu()
    stacks=new stackManager({})
    counters=new counterBox(countersOriginal)
    counterdisplayer=new counterDisplayer(counters)
    windowmanager=new windowManager('overlay',{},counterdisplayer,true)
    windowmanagermenu=new windowManager('moverlay',{
        leftSide:'right',bottomSide:'top',myleftmargin:20
    },counterdisplayer,true)
    if (map === undefined) {
        initializeMap()
    } else {
        for (var i in map_hooks) {
            map_hooks[i]()
        }
    }
}

localNick='Anonymous'

server=new fakeServer()

// }}}


// Define map
// map,projection
// map_hooks.push(f) [execute f after map setup]
// projection.fromPixelToLatLng(map,x,y) [pixel bottom left]
// {x:,y:}=projection.fromLatLngToPixel(map,latLng) [pixel bottom left]
// {{{

function euclideanProjection() {
}
euclideanProjection.prototype.fromLatLngToPoint = function(latLng,opt_point) {
    var point = opt_point || new google.maps.Point(0, 0)
    // by doing that, we assert that 1 pixel of the map google zoom 0 occupies
    // 1 degree in each dimension
    // So 1 pixel at zoom ZOOMREF (for us) is 1/2^(ZOOMREF+ZOOMOFFSET) degrees
    point.x = latLng.lng()
    point.y = -latLng.lat()
    return point
}
euclideanProjection.prototype.fromPointToLatLng = function(point) {
    var me = this
    var origin = me.pixelOrigin_
    var lng = point.x
    var lat = -point.y
    return new google.maps.LatLng(lat , lng, true)
}
euclideanProjection.prototype.fromPixelToLatLng = function(map,x,y) {
    var m=map.getBounds()
    if (!m)
        return new google.maps.LatLng(0, 0, true)
    var zoom=1<<(map.getZoom())
    var sw=m.getSouthWest()
    if (!sw)
        return new google.maps.LatLng(0, 0, true)
    var xx=x/zoom+sw.lng()
    var yy=y/zoom+sw.lat()
    return new google.maps.LatLng(yy, xx, true)
}
euclideanProjection.prototype.fromLatLngToPixel = function(map,latLng) {
    var m=map.getBounds()
    var sw=m.getSouthWest()
    var zoom=1<<(map.getZoom())
    var x=latLng.lng()-sw.lng()
    var y=latLng.lat()-sw.lat()
    return {x:x*zoom,y:windowheight-y*zoom}
}
// Initialisation of the map.


function initializeMap() {
    projection = new euclideanProjection()
    origin=new google.maps.LatLng(0,0)
    var mapOptions = {
        zoom: ZOOMOFFSET+5,
        center: new google.maps.LatLng(0,0),
        mapTypeControl: false,
        zoomControl: false,
        streetViewControl: false,
        scaleControl: false,
        panControl: false,
    }
    var boardOptions = {
        getTileUrl: function(coord, zoom) {
            var z=zoom-ZOOMOFFSET
            // Should never happen
            if (z<0) return "img/bkgnd.png"
            var numTiles = 1 << z
            // (0,0) is in the bottom corner
            var newx = coord.x
            var newy=-1-coord.y
            if (newx < 0 || newx >= numTiles) return "img/bkgnd.png"
            if (newy < 0 || newy >= numTiles) return "img/bkgnd.png"
            return XBASE+"tile_" +
                z + "/" + newx + "_" + (newy) + ".png"
        },
        tileSize: new google.maps.Size(TILESIZE, TILESIZE),
        isPng: true,
        name: 'Board',
        maxZoom: ZOOMREF+ZOOMOFFSET,
        minZoom: ZOOMOFFSET,
    }
    var boardMapType = new google.maps.ImageMapType(boardOptions)
    boardMapType.projection=projection
    map = new google.maps.Map(document.getElementById("map_canvas"),mapOptions)
    map.mapTypes.set('board',boardMapType)
    map.setMapTypeId('board')
    google.maps.event.addListenerOnce(map,'dragstart', function() {
        $('#map_canvas a[href^=http://maps.google.com]').parent().delay(2000).fadeOut().remove()
        $('#map_canvas a[href^=http://www.google.com]').parent().parent().delay(2000).fadeOut().remove()
    })
    for (var i in map_hooks) {
        var f=map_hooks[i]
        f()
    }
}

// }}}

// Stacks on board management
// Useful globals:
// stacks: array containing all stacks description

// stacks.updatePosition(x,p,v)
// stacks.updateContent(c,xf,xt,r,v) [xf,xt:<0 means box, else stack from/to]
// x=stacks.newStack(x?,p,v) [x auto-attributed if undefined]
// stacks.destroyStack(x) [only if empty]
// stacks.updateViewMap(b) [updates views in case map moves/zooms]
// {{{

stackManager=function(ar) {
    this.s=ar
    this.listeners=[]
    this.lv={}
    var t=this
    map_hooks['stackManager']=function () {t.register_listeners()}
}

stackManager.prototype.register_listeners=function() {
    this.listeners.push(google.maps.event.addListener(
        map, 'zoom_changed', stacks.updateViewMap
    ))
    this.listeners.push(google.maps.event.addListener(
        map, 'bounds_changed', stacks.updateViewMap
    ))
    this.listeners.push(google.maps.event.addListener(
        map, 'center_changed', stacks.updateViewMap
    ))
}

stackManager.prototype.destroy=function() {
    // Remove listeners
    for (var k in this.listeners) {
        google.maps.event.removeListener(this.listeners[k])
    }
    delete stacks.listeners
    delete stacks.lv;
    // Close windows, remove markers, clear stack
    for (var k in this.s) {
        var owin=windowManager.getWindow(this.s[k])
        if (owin) owin.close(true)
        var m=this.s[k].marker
        if (m) {
            m.setMap(null)
            delete this.s[k].marker
            delete this.s[k].markerZoom
        }
        // This is dangerous. Counters must be updated after that!
        this.s[k].content=[]
        this.deleteStack(k)
    }
    delete stacks.s
    delete map_hooks['stackManager']
}

stackManager.prototype.updateViewMap=function(force) {
    // No assertions
    var zoom=map.getZoom()
    var center=map.getCenter().toString()
    // This may not be initialized
    var bounds=map.getBounds().toString()
    var lv=stacks.lv
    if  (force||lv===undefined||MARKERDELTA!=lv.markerdelta||
         zoom!=lv.zoom||center!=lv.center||bounds!=lv.bounds) {
        var changedzoom=(zoom!=lv.zoom)
        var z=stacks.getZoom()
        if (stacks.updateVisible())
            stackoverview.update()
        for (var i in stacks.s) {
            stacks.updateMarker(i,z)
        }
        lv.zoom=zoom
        lv.center=center
        lv.bounds=bounds
        lv.markerdelta=MARKERDELTA
    }
    return true
}

stackManager.prototype.updateMarker=function(x,z,changedimage,changedposition,changednick) {
    // No return code
    // No assertions, this is an internal fast function
    // Three choices: destruction, creation, update
    if (this.s[x]===undefined) return
    if (z===undefined) z=this.getZoom()
    var s=this.s[x]
    var m=s.marker
    var marker
    var t=this
    // Destruction
    if (z<ZOOMMARKER)
        if (m===undefined) {
            return false
        } else {
            m.setMap(null)
            delete s.marker
            delete s.markerZoom
            return true
        }
    if (m===undefined) {
        // Create from scratch anyway
        var ss=this.getSize(s.size,z)
        m=new google.maps.Marker({
            position: s.position,
            title: (s.nick?s.nick:'Content')+'\n'+(s.title.replace(/, /g,'\n')),
            map: map,
            icon: new google.maps.MarkerImage(
                s.imagep+z+s.images,ss[0],pointzero,ss[1]
            ),
            draggable: true,
            clickable: true,
        })
        google.maps.event.addListener(m, 'dragend', function(event){
            var r=contours.transformCoordLocation(t.s[x].position)
            var rr=contours.transformCoordLocation(event.latLng)
            var mm,mt
            if (rr===r) {
                mt='Stack barely moved'
                mm='This stack is loitering in <span class="msgloc">'+r+
                    '</span>'
            } else {
                mt='Stack moved'
                mm='This stack moves from <span class="msgloc">'+r+
                    '</span> to <span class="msgloc">'+rr+'</span>.'
            }
            ordermanager.ooqueue({
                t:OMO.MOVESTACK,
                a:x,
                p:latLngToArray(event.latLng),
                mi: 'img/movestack.png',
                ms: CELLSIZES[0],
                mm: mm,
                mt: mt
            })
        })
        google.maps.event.addListener(m, 'click', function(event) {
            stackZoom.raise(x)
        })
    } else {
        if (s.markerzoom!=z || changedimage) {
            var ss=stacks.getSize(s.size,z)
            m.setIcon(new google.maps.MarkerImage(
                s.imagep+z+s.images,ss[0],pointzero,ss[1]
            ))
        }
        if (changedimage || changednick) {
            m.setTitle((s.nick?s.nick:'Content')+'\n'+
                       (s.title.replace(/, /g,'\n')))
        }
        if (changedposition) {
            m.setPosition(s.position)
        }
    }
    s.marker=m
    s.markerzoom=z
}

// Manage zooms and icon sizes
stackManager.prototype.getZoom=function() {
    var z=map.getZoom()-ZOOMOFFSET+MARKERDELTA
    if (z<=ZOOMREF) return z
    else return ZOOMREF
}
stackManager.prototype.getSize=function(s,z) {
    var sz=SIZESCACHE[z]
    if (sz!==undefined && sz[s]!==undefined) return sz[s]
    if (sz===undefined)
        sz=SIZESCACHE[z]=[]
    var xdiv=1<<(ZOOMMARKERSIZEREF-z)
    var ss=Math.ceil(s/xdiv)
    var sc=Math.ceil(s/(2*xdiv))
    sz[s]=[new google.maps.Size(ss,ss),new google.maps.Point(sc,sc)]
    return sz[s]
}


stackManager.prototype.update=function(x,changeddetail) {
    // Commits all changes to stack
    // Should be called every time one of these changed
    // If one changed, recreates marker (permanent view)
    assert(this.s[x]!==undefined,'Stack #'+x+' is undefined')
    var s=this.s[x]
    var changednew=false
    var changedregion=false
    var changedposition=false
    var changedvisible=false
    var changedimage=false
    var changednick=false
    if (s._content!==undefined) {
        if (s.content.toString()!=s._content.toString()) {
            s.content=s._content
            changedimage=true
        }
        delete s._content
    }
    var changedimageindex=['images','imagep','size','title']
    this.updateTitleImage(x)
    for (var i=changedimageindex.length-1;i>=0;i--) {
        var a=changedimageindex[i]
        var b='_'+a
        if (s[a]!=s[b]) {
            s[a]=s[b]
            changedimage=true
        }
        delete s[b]
    }
    if (s._visible !== undefined && s._visible != s.visible) {
        changedvisible=true
        s.visible=s._visible
    }
    delete s._visible
    if (s._nick !== undefined && s._nick != s.nick) {
        changednick=true
        s.nick=s._nick
        if (s.nick) s.xnick=s.nick
        else s.xnick='['+s.title+']'
    }
    delete s._nick
    if (changedimage && !s.nick) {
        s.xnick='['+s.title+']'
    }
    if (s._position !== undefined && s._position != s.position) {
        changedposition=true
        s.position=s._position
    }
    delete s._position
    if (s._region !== undefined && s._region != s.region) {
        changedregion=true
        s.region=s._region
    }
    delete s._region
    if (changedimage || changedposition || changednick) {
        this.updateMarker(x,undefined,changedimage,changedposition,
                          changednick)
    }
    if (changedregion || changedvisible || (s.visible && changedimage)) {
        stackoverview.update()
    }
    var owin=-1
    if ((changedregion || changednick) && !(changedimage && s.wm)) {
        owin=windowManager.getWindow(s)
        if (owin !== undefined)
            owin.updateTitle(s.nick?(s.nick+' / '+s.region):s.region)
    }
    if (s.wm && (changedimage||changeddetail)) {
        if (owin == -1)
            owin=windowManager.getWindow(s)
        if (owin !== undefined)
            owin.update()
    }
}

stackManager.prototype.updateTitleImage = function(x) {
    // updates title and image properties
    // No view updates
    // No assertions.
    // Could assert s defined.
    var s=this.s[x]
    // if (s===undefined) return
    var list=s.content
    var titlecounter=''
    var size
    var im
    switch (list.length) {
    case 0:
        titlecounter='Empty'
        imagep=BASE+'unknown'
        images='.png'
        size=STACKMARKERSIZES[1]
        break
    case 1:
        im=counterdisplayer.imagename(list[0])
        titlecounter=im[1]
        size=MARKERSIZES[im[3]]
        imagep=PBASE+"counter_"
        images="/"+im[0]
        break
    default:
        var csize=-1
        var increasinglylarge=[]
        imagep=BASE+"merge.php?z="
        for (var i=list.length-1;i>=0;i--) {
            im=counterdisplayer.imagename(list[i])
            titlecounter+=', '+im[1]
            if (im[3]>csize) {
                increasinglylarge.push({name:im[0],size:im[3]})
                csize=im[3]
            }
        }
        titlecounter=titlecounter.substr(2)
        size=STACKMARKERSIZES[csize]
        images=''
        for (var i in increasinglylarge) {
            images+=(increasinglylarge[i].size?'&b=':'&s=')
            images+=increasinglylarge[i].name
        }
    } // end switch list.length
    s._title=titlecounter
    s._imagep=imagep
    s._images=images
    s._size=size
}
stackManager.prototype.updateVisible = function(x) {
    // No arguments: check all stacks (maps move)+update views
    // Argument x: initial setup of visibility of position change
    //
    // Right now, the visibility of the markers does not change
    // because markers may come into view before event bounds_changed
    // is fired.
    // No assertion
    var m=map.getBounds()
    var w=m.getSouthWest().lng()
    var s=m.getSouthWest().lat()
    var e=m.getNorthEast().lng()
    var n=m.getNorthEast().lat()
    var cont
    if (x===undefined) {
        cont=this.s
        arg='visible'
    } else {
        cont=[this.s[x]]
        arg='_visible'; // two-fold update
    }
    var changed=false
    for (var i in cont) {
        var z=cont[i]
        var pp=z._position
        if (pp===undefined)
            pp=z.position
        var x=pp.lng()
        var y=pp.lat()
        if (w<=x && x<=e && s<=y && y<=n) {
            if (!z.visible) {
                z[arg]=true
                changed=true
            }
        } else {
            if (z.visible) {
                z[arg]=false
                changed=true
            }
        }
    }
    return changed
}

stackManager.prototype.updateNick=function(x,n,noview) {
    assert(x !== undefined,'Stack number is undefined')
    assert(this.s[x] !== undefined,'Stack #'+x+' is undefined')
    var s=this.s[x]
    if (!n) {
        s._nick=''
        //        message('text','<em>'+s.nick+'</em> lost his name (now '+s.title+
        //                ')','Dishonour')
    } else {
        s._nick=n
        //        message('text','<em>'+(s.nick?s.nick:x.xnick)+'</em> was named <em>'+
        //                s._nick+'</em>','Christening')
    }
    if (!noview)
        this.update(x)
}

stackManager.prototype.updatePosition=function(x,p,noview) {
    assert(p && p.length==2,'New position is undefined')
    assert(x !== undefined,'Stack number is undefined')
    assert(this.s[x] !== undefined),'Stack #'+x+' is undefined'
    var s=this.s[x]
    s._position=arrayToLatLng(p)
    s._region=contours.transformCoordLocation(s._position)
    this.updateVisible(x)
    if (!noview) {
        //        if (s._region != s.region) {
        //            message('movestack','<em>'+s.xnick+'</em> has moved to '+s._region)
        //        }
        this.update(x)
    }
}

stackManager.prototype.updateContent=function(c,a,b,q,noview) {
    // Counter c is moved from stack a to b
    // if a or b is negative, it represents the counters box.
    // If noview=true, do not do the updates
    var p
    // Assertions
    var isboxa=(a=='box')
    var isboxb=(b=='box')
    var cc=counters.s[c]
    assert(c!==undefined,'No counter involved')
    assert(cc !== undefined,'Counter #'+c+' is undefined')
    assert(this.s[a]||isboxa,'Stack #'+a+' is undefined')
    assert(this.s[b]||isboxb,'Stack #'+b+' is undefined')
    assert(isboxa|| counters.s[c].stack == a,
           'Counter #'+c+' not in stack #'+a)
    assert(!isboxa|| !(counters.s[c].stack),
           'Counter #'+c+' not in box')
    var cb
    if (!isboxb) {
        cb=this.s[b]._content
        if (cb===undefined)
            cb=this.s[b].content
        assert(q<cb.length || (q==cb.length && a!=b),
               'Stack #'+b+' is too small for '+q)
    }
    var sa
    var sb
    if (!isboxa) {
        // Find the counter in stack A
        sa=this.s[a]
        var ca=sa._content
        if (ca===undefined)
            ca=sa.content
        p=ca.indexOf(c)
        assert(p != -1,'Counter #'+c+' not found in stack #'+a)
    }
    // Model changes
    if (isboxa) {
        c=counters.boxToBoard(c)
    } else {
        sa._content=ca.slice()
        sa._content.splice(p,1)
    }
    if (isboxb) {
        c=counters.boardToBox(c)
    } else {
        if (a!=b) {
            sb=this.s[b]
            sb._content=cb.slice()
            sb._content.splice(q,0,c)
            counters.s[c].stack=b
        } else {
            sb=sa // Needed ?
            // We removed something already
            sa._content.splice(q,0,c)
        }
    }
    if (!isboxa) {
        if (a==b) {
            //            xmessage(counterdisplayer.image(c),
            //                     '<em>'+sa.xnick+'</em> was reordered','Reorganisation')
        } else if (!isboxb) {
            //            xmessage(counterdisplayer.image(c),
            //                     '<em>'+sb.xnick+'</em> received one counter from <em>'+
            //                     sa.xnick+'</em>','Transfer')
        } else {
            //            xmessage(counterdisplayer.image(c),
            //                     '<em>'+sa.xnick+'</em> lost one counter','Lost counter')
        }
    } else {
        //        if (!isboxb) {
        //            xmessage(counterdisplayer.image(c),
        //                     '<em>'+sb.xnick+'</em> received one counter','New counter')
        //        } else {
        //            xmessage(counterdisplayer.image(c),
        //                     'Somebody plays with the counters','Nothing')
        //        }
    }
    if (noview) return
    // Update views
    if (!isboxa)
        this.update(a)
    if (!isboxb && a!=b)
        this.update(b)
    if (isboxa || isboxb) {
        var ws=windowmanager.searchWindows(PICKERTYPE)
        for (var i in ws) {
            ws[i].update()
        }
    }
}

stackManager.prototype.getId=function() {
    var uid=server.uid
    var i=0
    while (this.s[uid+i] !== undefined) i++
    return uid+i
}

stackManager.prototype.newStack=function(p,id,noview) {
    // Create a new empty stack at latLng
    // Use id if given.
    // if noview, do not update view.
    assert(p && p.length==2,'New position is undefined')
    if (id===undefined)
        id=this.getId()
    this.s[id]={
        marker: undefined,
        nick: '',
        xnick: '',
        title: '?',
        content: [],
        imagep: undefined,
        images: undefined,
        position: undefined,
        size: undefined,
        visible: undefined,
    }
    var s=this.s[id]
    this.updatePosition(id,p,true)
    this.updateTitleImage(id,p,true)
    s.xnick='['+s._title+']'
    if (!noview)
        this.update(id)
    return id
}

stackManager.prototype.deleteStack=function(a) {
    // Delete empty stack #a
    var s=this.s[a]
    assert(s !== undefined,'Stack #'+a+' is undefined')
    assert(s.content.length == 0,'Stack #'+a+' is not empty')
    var owin=windowManager.getWindow(s)
    var marker=s.marker
    // Model changes
    var s=this.s[a]
    //    message('delstack','<em>'+s.xnick+'</em> was dissolved','Stack dissolution')
    delete s.marker
    delete s.markerzoom
    delete s.wm
    delete s.owin
    delete s.nick
    delete s.xnick
    delete s.title
    delete s.content
    delete s.imagep
    delete s.images
    delete s.position
    delete s.size
    delete s.visible
    delete stacks.s[a]
    // Destroy views
    if (marker) {
        marker.setMap(null)
    }
    if (owin !== undefined) {
        owin.close()
    }
}

// }}}

// Counter display management
// Useful globals:
// counterdisplayer.repr(x,owin): returns a jQ element representing counter x
// {{{

function counterDisplayer(c) {
    this.c=c
    this.i=0
}

counterDisplayer.prototype.imagename=function(x) {
    var t,d,im,k,v
    t=this.c.s[x]
    d=!!(t.a.side.m)
    im=t.f
    if (d) {
        v=t.a.side.c
        if (!v) {
            im+='_recto'
        } else {
            im+='_verso'
        }
        k=t.k[v]
    } else {
        k=t.k[0]
    }
    im+='.png'
    return[im,k,CELLSIZES[1+t.b],t.b]
}

counterDisplayer.prototype.image=function(x) {
    var im=this.imagename(x)
    return this.cell('<img alt="'+im[1]+'" src="'+PBASE+'counter_5/'+im[0]+
                     '">',im[2],im[2]).
        attr('title',im[1])
}

counterDisplayer.prototype.repr=function(x,data) {
    var a,w,h,ww,www,hh,il,kl,k,v,kk,jj,imgs,wimgs,limgs,kimgs
    var t=this.c.s[x]
    var tt=this
    var im=this.imagename(x)
    h=w=im[2]
    hh=ww=0
    www=CELLSIZES[0]
    var style={}
    var i=$('<div class="img"><img alt="'+im[1]+'" src="'+PBASE+'counter_5/'+
            im[0]+'" /></div>')
    var j=$('<div class="cnt" />')
    var flip=function() {}
    var info=function(e) {tt.info(x,e)}
    if (t.a.side.m) {
        ww=10
        i.addClass('counterMultiSides')
        flip=function(e) {tt.flip(x,e)}
    }
    i.css({width:w,height:h,position:'absolute',top:0,left:(www-ww-w)/2}).
        appendTo(j)
    jj=$('<div class="crc" />')
    hh=0
    ww=-1
    limgs=[]
    wimgs=[]
    imgs=[]
    kimgs=[]
    for (v in t.a) {
        if (CELLLAYERS[v]) {
            kl=CELLLAYERS[v][t.a.side.c]
            kimgs.push(kl)
            if (kl[2]>hh) hh=kl[4]
            k=t.a[v].c
            if (k>kl[2]) k=kl[2]
            if (k<kl[1]) k=kl[1]
            kk=''+kl[0]+k
            ww=ww+1
            limgs.push(ww)
            ww=ww+LAYERSIZES[kl[0]][k]
            imgs.push(kk)
            wimgs.push(LAYERSIZES[kl[0]][k])
        }
    }
    // hh is now the max-height of the indicators
    if (hh>0) {
        jj.appendTo(j).css({
            position:'absolute',
            top:h,
            left:0,
            width: www,
            height:hh
        })
        www=(www-ww)/2
        for (v=0;v<imgs.length;v++) {
            kl=kimgs[v]
            k=$('<div class="img"><img alt="'+imgs[v]+'" src="img/layers/'+
                imgs[v]+'.png" /></div>').
                css({
                    position: 'absolute',
                    top:kl[3],
                    left:www+limgs[v],
                    height:kl[4],
                    width:wimgs[v],
                }).appendTo(jj)
        }
    }
    return this.cell(j,hh+h).
        attr('title',im[1]).
        multiClick(data,{
            simpleClick:flip,
            longClick:info,
            dragStart:dragDrop.mousedown,
            dragMove:dragDrop.mousemove,
            dragStop:dragDrop.mouseup,
            end:context.normal
        })
}

counterDisplayer.prototype.flip=function(x) {
    var t=this.c.s[x]
    if (t.a.side.m) {
        var s=(t.a.side.c+1)%(t.a.side.m+1)
        ordermanager.ooqueue({
            t:OMO.ALTERCOUNTER,
            c:x,
            v:{'side':s},
            mt: 'Change counter',
            mi: 'img/modcounter.png',
            mm: 'This counter is modified',
            ms: CELLSIZES[0],
        })
    }
    return true
}

counterDisplayer.prototype.info=function(x) {
    if (context.context==1) return
    var t=this.c.s[x]
    var s=CELLSIZES[0]
    var tt=this
    function change(a,b) {return function() {tt.changeInfo(a,b)}}
    var im=this.imagename(x)
    $('#modal').remove()
    modal.array={}
    for (var i in t.a) {
        if (CELLLAYERS[i]===undefined) continue
        modal.array[i]={}
        for (var j in t.a[i]) {
            modal.array[i][j]=t.a[i][j]
        }
    }
    modal.cnum=x
    modal.sidef=t.f
    modal.side=t.a.side.c
    modal.sidem=t.a.side.m
    modal.siden=t.a.side.n
    var l=$('<table id="modaltable">')
    var kka=$('<tr/>').appendTo(l)
    $('<th style="width: '+s+'px">Side</th>').appendTo(kka).
        click(change('side',-1))
    $('<td id="modalrowside" style="width: '+s+'px;height: '+
      CELLSIZES[t.b+1]+'px"><img /></td>').appendTo(kka).
        multiClick({},{
            simpleClick:change('side',1),
            longClick:change('side',-1)
        })
    for (var i in modal.array) {
        var kka=$('<tr />').appendTo(l)
        $('<th style="width: '+s+'px">'+CELLLAYERS[i][0][5]+'</th>').
            click(change(i,-1)).
            appendTo(kka)
        $('<td id="modalrow'+i+'" style="width: '+s+
          'px;height: '+CELLLAYERS[i][0][4]+'px"><img /></td>').
            multiClick({},{
                simpleClick:change(i,1),
                longClick:change(i,-1)
            }).appendTo(kka)
    }
    var k=$('<div id="modal" class="modalWindow" />').
        append(l).
        appendTo($('body')).
        css('textAlign','center').
        centerScreen()
    var kka=$('<tr />').appendTo(l)
    $('<td class="button">Cancel</td>').css('width',s).
        click(function(){tt.cancelInfo()}).
        appendTo(kka)
    $('<td class="button">Save</td>').css('width',s).
        click(function(){tt.saveInfo()}).
        appendTo(kka)
    this.updateInfo()
    return true
}

counterDisplayer.prototype.updateInfo=function() {
    var kl,k,kk,ki,kf
    for (var v in modal.array) {
        if (CELLLAYERS[v]===undefined) continue
        kl=CELLLAYERS[v][modal.side]
        k=modal.array[v].c
        if (k>kl[2]) k=kl[2]
        if (k<kl[1]) k=kl[1]
        kk=''+kl[0]+k
        ki=$('<img alt="'+kk+'" src="img/layers/'+kk+'.png" />')
        $('#modalrow'+v+' img').attr('src','img/layers/'+kk+'.png')
    }
    kf=modal.sidef+COUNTERSIDES[modal.sidem][modal.side]
    $('#modalrowside img').attr('src',PBASE+'counter_5/'+kf+'.png')
}

counterDisplayer.prototype.changeInfo=function(a,b) {
    if (a!='side') {
        var c=modal.array[a]
        var d=CELLLAYERS[a][modal.side]
        c.c+=b
        if (c.c<c.n) c.c=c.m
        if (c.c>c.m) c.c=c.n
        if (c.c<d[1]) c.c=d[1]
        if (c.c>d[2]) c.c=d[2]
    } else {
        modal.side+=b
        if (modal.side>modal.sidem) modal.side=modal.siden
        if (modal.side<modal.siden) modal.side=modal.sidem
    }
    this.updateInfo()
}
counterDisplayer.prototype.saveInfo=function() {
    var changes={}
    var changed=false
    modal.array.side={}
    modal.array.side.c=modal.side
    modal.array.side.m=modal.sidem
    modal.array.side.n=modal.siden
    var a=this.c.s[modal.cnum].a
    for (var i in modal.array) {
        if (modal.array[i].c!=a[i].c) {
            changes[i]=modal.array[i].c
            changed=true
        }
    }
    if (changed)
        ordermanager.ooqueue({
            t:OMO.ALTERCOUNTER,
            c:modal.cnum,
            v:changes,
            mt: 'Change counter',
            mi: 'img/modcounter.png',
            mm: 'This counter is modified',
            ms: CELLSIZES[0],
        })
    this.cancelInfo()
}

counterDisplayer.prototype.cancelInfo=function() {
    delete modal.side
    delete modal.sidem
    delete modal.siden
    delete modal.array
    delete modal.sidef
    delete modal.cnum
    $('#modal').remove()
}

counterDisplayer.prototype.cell=function(inner,h,w) {
    var a,b,s,hh,ww
    s=CELLSIZES[0]
    if (h===undefined) {h=s}
    hh=(s-h)/2
    a=$(inner)
    if (w!==undefined) {
        ww=(s-w)/2
        a.css({
            display:'inline-block',
            height: h,
            top: hh,
            left: ww,
            width: w,
            position:'absolute',
        })
    } else {
        a.css({
            height:h,
            width:s,
            top: hh,
            left:0,
            position:'absolute',
        })
    }
    var b=$('<div class="cell"></div>').append(a).css({
        display:'inline-block',
        verticalAlign:'middle',
        textAlign: 'center',
        width: s,
        position:'relative',
        lineHeight:0,
        height: s,
    })
    return b
}

counterDisplayer.prototype.button=function(oname,text) {
    var inner=$('<img src="img/'+oname+'.png" alt="['+oname+']"/>')
    if (text) {
        inner.attr('title',text)
    }
    return this.cell(inner)
}

// }}}

// Specialized draganddrop
// {{{

var dragDrop
dragDrop={}

function testPos(x,y,c) {
    $('#toto'+c).remove()
    $('<div id="toto'+c+'" />').
        css({backgroundColor:c,top:y,left:x,
             height:2,width:2,position:'absolute'}).
        appendTo('body')
}

dragDrop.defaults={
    counter: undefined,
    firstStack: undefined,
    firstWindow: undefined,
    wm: undefined,
    owin: undefined,
    originalitem: undefined,
    item: undefined,
    offsetX: undefined,
    offsetY: undefined,
    hotX: undefined,
    hotY: undefined,
    lastWindow: undefined,
    replacementRank: undefined,
    initialRank:undefined,
}
dragDrop.cancel=function(e) {
    context.normal()
    $('#moving').remove()
    $('.'+dragDrop.wm.prefix+'-selected').removeClass(dragDrop.wm.prefix+'-selected')
    dragDrop.removePlaceholder()
    $.extend(dragDrop,dragDrop.defaults)
}
dragDrop.replacement=function(x,h) {
    return $('<div class="'+x+'"/>').css({
        width: dragDrop.width,
        height: h?dragDrop.height:0,
        display:'inline-block',
        verticalAlign: 'middle'
    })
}

dragDrop.mousedown=function(e) {
    var ex=e.pos[0];var ey=e.pos[1]
    dragDrop.wm=e.data.wm
    dragDrop.initialWindow=dragDrop.owin=e.data.owin
    dragDrop.counter=e.data.counter
    dragDrop.initialStack=e.data.stack
    dragDrop.initialRank=e.data.rank
    var item=$(this)
    dragDrop.item=item.clone(false,false)
    dragDrop.height=item.height()
    dragDrop.width=item.width()
    var pos=item.offset()
    dragDrop.offsetX=ex-pos.left
    dragDrop.offsetY=ey-pos.top
    dragDrop.hotX=Math.round(dragDrop.width/2)-dragDrop.offsetX
    dragDrop.hotY=Math.round(dragDrop.height/2)-dragDrop.offsetY
    context.dragDrop()
    if (dragDrop.initialStack=='box') {
        item.css('opacity',0)
    } else {
        item.hide(ANIMATIONTIME)
        item.removeClass('cell')
    }
    dragDrop.item.css({
        position:'absolute',
        display:'block',
        opacity: 0.5,
    }).attr('id','moving').appendTo('body')
    dragDrop.lastWindow=-2; // invalid
    dragDrop.lastStack=dragDrop.initialStack
    dragDrop.lastRank=dragDrop.initialRank; // invalid
}

dragDrop.mousemove=function(e) {
    var ex=e.pos[0]
    var ey=e.pos[1]
    var yy=ey-dragDrop.offsetY
    dragDrop.item.css({
        left: ex-dragDrop.offsetX,
        top: yy
    })
    var owin=dragDrop.wm.search(ex+dragDrop.hotX,ey+dragDrop.hotY)
    var lastStack='out'
    var w=-1
    if (owin!==undefined) {
        w=owin.id
        if (owin.obj.type==PICKERTYPE)
            lastStack='box'
        else if (owin.obj.type==STACKZOOMTYPE)
            lastStack=owin.obj.stacknumber
    }
    if (w!=dragDrop.lastWindow) {
        if (dragDrop.lastWindow>=0) {
            dragDrop.owin=dragDrop.lastWindow
            var lwin=windowManager.getWindow(dragDrop)
            if (dragDrop.lastStack != 'box')
                dragDrop.removePlaceholder(lwin)
            lwin.content.removeClass(dragDrop.wm.prefix+'-selected')
        }
        dragDrop.lastWindow=w
        dragDrop.lastStack=lastStack
        if (w>=0)
            owin.content.addClass(dragDrop.wm.prefix+'-selected')
    }
    if (w == -1 || owin.obj.type != STACKZOOMTYPE) return false
    // TODO: Not revised from here
    dragDrop.pos=[]
    var pp=dragDrop.pos
    var tbp=0
    // Fragile: uses the fact that they come in right order
    var cells=owin.content.children('.cell')
    cells.each(dragDrop.analysis);
    // We have stored the middle position of each cell
    for (var i=0;i<pp.length;i++) {
        if (yy<pp[i]) break
    }
    tbp=i
    xtbp=cells.length-tbp
    if (xtbp!=dragDrop.replacementRank) {
        dragDrop.removePlaceholder(owin)
        var repl=dragDrop.replacement('placeholder',false)
        if (tbp==0) {
            owin.content.prepend(repl)
        } else {
            var k=owin.content.children('.cell').get(tbp-1)
            $(k).after(repl)
        }
        repl.animate({height:dragDrop.height},ANIMATIONTIME)
        dragDrop.replacementRank=xtbp
    }
    return false
}


dragDrop.mouseup=function(e) {
    var ex=e.pos[0]
    var ey=e.pos[1]
    var ns
    var owin
    var wm=dragDrop.wm
    var im=wm.displayer.imagename(dragDrop.counter)
    var mt,mm
    if (dragDrop.lastStack=='out') {
        var p=projection.fromPixelToLatLng(
            map, ex+dragDrop.hotX, windowheight-ey-dragDrop.hotY
        )
        ns=ordermanager.ooqueue({
            t: OMO.CREATESTACK,
            p: latLngToArray(p),
            mt: 'New stack',
            mi: 'img/newstack.png',
            ms: CELLSIZES[0],
            mm: 'A new stack is created in <span class="msgloc">'+
                contours.transformCoordLocation(p)+'</span>.'
        })
        if (dragDrop.initialStack==='box') {
            mt='New counter'
            mm='A new counter is added to this stack'
        } else {
            mt='Transferred counter'
            mm='A counter is moved from position '+dragDrop.initialRank+
                ' of that stack to this stack'
        }
        ordermanager.ooqueue({
            t: OMO.CHANGESTACK,
            a: dragDrop.initialStack,
            b: ns,
            c: dragDrop.counter,
            q: 0,
            mt: mt,
            mi: PBASE+'counter_5/'+im[0],
            ms: im[2],
            mm: mm
        })
    } else if (dragDrop.lastStack=='box') {
        if (dragDrop.initialStack!='box') {
            ordermanager.ooqueue({
                t: OMO.CHANGESTACK,
                a: dragDrop.initialStack,
                b: dragDrop.lastStack,
                c: dragDrop.counter,
                mt: 'Lost counter',
                mi: PBASE+'counter_5/'+im[0],
                ms: im[2],
                mm: 'A counter is removed from that stack'
            })
        } else {
            var ws=windowmanager.searchWindows(PICKERTYPE)
            for (var i in ws) {
                ws[i].update()
            }
        }
    } else {
        if (dragDrop.initialStack==dragDrop.lastStack &&
            dragDrop.initialRank==dragDrop.replacementRank) {
            var owin=windowManager.getWindow(dragDrop)
            if (owin) owin.update()
        } else {
            if (dragDrop.initialStack===dragDrop.lastStack) {
                mt='Reorganised stack'
                mm='A counter is moved from position '+dragDrop.initialRank+
                    ' to position '+dragDrop.replacementRank+
                    ' of this stack'
            } else {
                mt='Transferred counter'
                mm='A counter is moved from position '+dragDrop.initialRank+
                    ' of that stack to position '+dragDrop.replacementRank+
                    ' of this stack'
            }
            ordermanager.ooqueue({
                t: OMO.CHANGESTACK,
                a: dragDrop.initialStack,
                b: dragDrop.lastStack,
                c: dragDrop.counter,
                q: dragDrop.replacementRank,
                mt: (dragDrop.initialStack===dragDrop.lastStack?
                     'Rearranged stack':'Transferred counter'
                    ),
                mi: PBASE+'counter_5/'+im[0],
                ms: im[2],
                mm: mm
            })
        }
    }
    dragDrop.cancel()
    return false
}
















dragDrop.removePlaceholder=function() {
    var kkk=$('.placeholder')
    kkk.clearQueue().animate({height:0},ANIMATIONTIME,function() {kkk.remove();})
    delete dragDrop.replacementRank
}

dragDrop.analysis=function(index) {
    var j=$(this)
    dragDrop.pos.push(j.height()/2+j.offset().top)
}
dragDrop.update=function(x,y) {
    var wm=dragDrop.wm
    var pickers=false
    if (x!==undefined && wm.c[x].obj.type == PICKERTYPE)
        pickers=true
    if (y!==undefined && wm.c[y].obj.type == PICKERTYPE)
        pickers=true
    for (var i=0;i<wm.c.length;i++) {
        var z=wm.c[i]
        if (z===undefined) continue
        if ((z.obj.type == PICKERTYPE && pickers)||
            i===x || i===y)
            z.obj.update()
    }
}

// }}}

// Counters management
// {{{

function counterBox(counters) {
    this.s=cloneCounters(counters)
    var root={}
    root._count=0
    this.tree=root
    var here
    var c
    var d
    for (var i=0;i<counters.length;i++) {
        c=counters[i]
        here=root
        for (var j=0;j<c.p.length;j++) {
            here._count++
            if (here._path === undefined) {
                here._path = c.p.slice(0,j)
            }
            d=c.p[j]
            if (!here[d]) here[d]={_count:0}
            here=here[d]
        }
        here._count++
        if (here._path === undefined) {
            here._path = c.p.slice(0,j)
        }
        here[i]=i
    }
}

counterBox.prototype.updateValues=function(x,a) {
    var st,i
    st=this.s[x]
    assert(st,'Counter #'+x+' is undefined')
    for (i in a) {
        assert(st.a[i],'Counter #'+x+' has no property '+i)
        assert(a[i]<=st.a[i].m && a[i]>=st.a[i].n,
               'Counter #'+x+' has invalid property '+i+'='+a[i])
    }
    for (i in a) {
        st.a[i].c=a[i]
    }
    st=this.s[x].stack
    if (st) {
        stacks.update(st,true)
    } else {
        var ws=windowmanager.searchWindows(PICKERTYPE)
        for (var i in ws) {
            ws[i].update()
        }
    }
}

counterBox.prototype.getId=function() {
    var uid=server.uid
    var i=0
    var c=this.s
    while (c[uid+i] !== undefined) i++
    return uid+i
}

counterBox.prototype.boxToBoard=function(x) {
    assert(this.s[x],'Counter #'+x+' is undefined')
    assert(this.s[x].stack===undefined,'Counter #'+x+' is already on board'+this.s[x].stack)
    if (this.s[x].i) {
        // Infinite counters
        var id=this.getId()
        this.s[id]=cloneCounter(this.s[x])
        this.s[id].origin=x
        x=id
    } else {
        var here=this.tree
        var path=this.s[x].p
        here._count--
        for (var j=0;j<path.length;j++) {
            here=here[path[j]]
            here._count--
        }
    }
    // Counter is in limbo
    this.s[x].stack=null
    return x
}
counterBox.prototype.boardToBox=function(x) {
    var o=x
    if (this.s[x].i) {
        o=this.s[x].origin
        delete this.s[x]
    } else {
        var here=this.tree
        var path=this.s[x].p
        here._count++
        for (var j=0;j<path.length;j++) {
            here=here[path[j]]
            here._count++
        }
        delete this.s[x].stack
    }
    return o
}

counterBox.prototype.alterate=function(x) {
    assert(this.s[x],'Counter #'+x+' is undefined')
}

counterBox.prototype.destroy=function() {
    delete this.s
    delete this.tree
}

// }}}

// Modal windows
// {{{

$(document).ready(function() {
    jQuery.fn.centerScreen = function(loaded) {
        var obj = this
        if(!loaded) {
            obj.css('position','absolute')
            obj.css('top', $(window).height()/2-this.height()/2)
            obj.css('left', $(window).width()/2-this.width()/2)
            $(window).resize(function() { obj.centerScreen(!loaded); })
        } else {
            obj.stop()
            obj.animate({
                top: $(window).height()/2-this.height()/2,
                left: $(window).width()/2-this.width()/2
            },ANIMATIONTIME)
        }
        return obj
    }
})

modal={}
modal.ask=function(title,callback) {
    assert(typeof(callback)=="function",'Callback is not a function')
    modal.callback=callback
    $('#modal').remove()
    $('<div id="modal" class="modalWindow">'+
      '<form id="modalform"><div>'+
      '<label for="modalquestion">'+title+
      '</label></div><div id="modalinput">'+
      '<input length="30" name="modalquestion" id="modalquestion" type="text" />'+
      '</div></form></div>').
        appendTo($('body')).css('textAlign','center').centerScreen()
    $('<input type="button" value="Cancel" />').appendTo($('#modalinput')).
        click(modal.cancel)
    $('#modalquestion').focus().submit(modal.answer)
    $('#modalform').submit(modal.answer)
}
modal.answer=function(e) {
    var q=$('#modalquestion')
    if (q) {
        modal.value=q.val()
        e.preventDefault()
        modal.callback()
        $('#modal').remove()
    }
}
modal.cancel=function(e) {
    delete modal.value
    e.preventDefault()
    $('#modal').remove()
}

// }}}

// Order manager
// {{{

orderManager=function() {
    this.q=[]
    this.pe={}
    this.id=0
}

// In an order we have
// Conflict areas
// a,b: stacks id
// c: counter id
// Administration
// v: values (associative array)
// t: type
// i: order id
// x: authoritative
// Other data
// p: position
// q: number (various uses: rank of insertion,...)
// s: string (various uses: stack name,..)

// If two orders have a,b or c in common, they are in conflict with each
// other. This means a non-authoritative order has to be undone
// non-authoritative orders are out of queue orders

OMO={
    CREATESTACK: 1,
    DELETESTACK: 2,
    RENAMESTACK: 3,
    MOVESTACK: 4,
    CHANGESTACK: 5,
    MESSAGE: 6,
    ALTERCOUNTER: 7
}
MOO=[]
for (var i in OMO)
    MOO[OMO[i]]=i

orderManager.prototype.ooqueue=function(o) {
    o.i=server.uid+(++(this.id))
    // Push in the send queue the order.
    server.sendOrder(o)
    // Mark event pending, and execute it.
    var oo=$.extend({},o)
    orderstorage.append(1,oo)
    oo.x=0
    this.pe[oo.i]=oo
    return this.exec(oo)
}
orderManager.prototype.queue=function(o) {
    assert(o && typeof(o)=='object','Order is not an object')
    assert(o.t,'Order is not typed')
    this.q.push(o)
    this.run()
}
orderManager.prototype.run=function() {
    // Cleans the queue, undoes wrongdoers, etc.
    var o
    var pending=this.pe
    var queue=this.q
    while (o=queue.shift()) {
        if (pending[o.i]) {
            if (!o.x) {
                // Full cancelation
                this.undo(o)
                // TODO: log error
            } else {
                // Full validation
                this.accept(o)
            }
        } else {
            // External order
            orderstorage.append(0,o)
            this.exec(o)
        }
    }
}

orderManager.prototype.exec=function(o) {
    switch (o.t) {
    case 1:
        assert(o.p && o.p.length==2,'New position is undefined')
        return stacks.newStack(o.p,o.a,false,o.s)
        break
    case 2:
        return stacks.deleteStack(o.a)
        break
    case 3:
        return stacks.updateNick(o.a,o.s,false)
        break
    case 4:
        return stacks.updatePosition(o.a,o.p,false)
        break
    case 5:
        return stacks.updateContent(o.c,o.a,o.b,o.q,false)
        break
    case 6:
        assert(PLAYERS[o.q],'Undefined player')
        //        message(PLAYERS[o.q][1],o.s,PLAYERS[o.q][0])
        return true
        break
    case 7:
        return counters.updateValues(o.c,o.v)
        break
    }
}
orderManager.prototype.undo=function(o) {
}
orderManager.prototype.reconciliate=function(o) {
}
orderManager.prototype.accept=function(o) {
    orderstorage.remove(1,o)
    orderstorage.append(0,o)
    delete this.pe[o.i]
}
orderManager.prototype.conflict=function(o,p) {
    // One/Two stacks orders
    var so={}
    var t=[o,p]
    var z=['a','b','c']
    for (var i=0;i<2;i++) {
        for (var j=0;j<3;j++) {
            var k=t[i][z[j]]
            if (k!==undefined) {
                if (so[k]) {
                    return true
                } else {
                    so[k]=true
                }
            }
        }
    }
    return false
}
ordermanager=new orderManager()

// }}}

// Region management
// Useful globals:
// contours.updateCoordinates(): update coordinates/region window
// contours.transformCoordLocation(point): returns region name of point
// {{{

// Normally, defined elsewhere
var contours
if (contours == undefined) {contours=[];}

function latLngToArray(a) {
    return [a.lng()*4096,a.lat()*4096]
}
function arrayToLatLng(a) {
    return new google.maps.LatLng(a[1]/4096,a[0]/4096)
}

contours.updateCoordinates=function(e) {
    var center
    if (e!==undefined) {
        contours.lastevent=e
    } else {
        e=contours.lastevent
    }
    if (contours.xy_ || contours.xyn_)
        center=projection.fromPixelToLatLng(map,e.pageX,windowheight-e.pageY)
    if (contours.xy_) {
        contours.xy=contours.transformCoordinates(center)
        contours.xy_.innerHTML=contours.xy
    }
    if (contours.xyn_) {
        contours.xyn=contours.transformCoordLocation(center)
        contours.xyn_.innerHTML=contours.xyn
    }
    if (contours.xyc_) {
        contours.xyc=contours.transformCoordLocation(map.getCenter())
        contours.xyc_.innerHTML=contours.xyc
    }
}
contours.transformCoordinates=function(center) {
    return(Math.round(center.lng()*4096)+';'+Math.round(center.lat()*4096))
}

contours.transformCoordLocation=function(point) {
    var x=Math.round(point.lng()*4096)
    var y=Math.round(point.lat()*4096)
    var name=false
    name=contours.testRegion(contours.lastRegion,x,y,true)
    if (name) return name
    if (x>=3500 && y >=3500 && x<=40955 && y <= 29465) {
        var kk=['Carte','CarteSource']
        for (var k in kk) {
            var m=contourssections[kk[k]]['e']
            for (var n=contourssections[kk[k]]['s'];n<m;n++) {
                var p=contours[n]
                // We do not check magic squares since they
                // are first in the list
                name=contours.testRegion(p,x,y,false)
                if (name) return name
            }
        }
        return('European map')
    }
    if (x>=3500 && y >=31945 && x<=40721 && y <= 57660) {
        var kk=['ROTWSource']
        for (var k in kk) {
            var m=contourssections[kk[k]]['e']
            for (var n=contourssections[kk[k]]['s'];n<m;n++) {
                var p=contours[n]
                // We do not check magic squares since they
                // are first in the list
                name=contours.testRegion(p,x,y,false)
                if (name) return name
            }
        }
        return('ROTW map')
    }
    return('Offboard')
}
contours.testRegion=function(p,x,y,m) {
    if (!p) return undefined
    if (x<p.b[0] || x>p.b[2] || y<p.b[1] || y>p.b[3])
        return false
    var debug=false
    if (p.t==2) return (p.n); // Magic squares
    if (m && p.m) { // test magic squares first
        for (var z=0;z<p.m.length;z++) {
            var name=contours.testRegion(contours[p.m[z]],x,y,m)
            if (name) {
                contours.lastRegion=contours[p.m[z]]
                return name
            }
        }
    }
    //    if (p.o=='prov008') debug=false
    var w=0
    var xa=-1
    var ya=-1
    var c=-1
    var d=-1
    var a=-1
    var b=-1
    var debugstring=''
    for (var m=0;m<p.c.length;m+=2) {
        a=c;b=d
        c=p.c[m]
        d=p.c[m+1]
        if (xa==-1) {
            xa=c;ya=d
            //            if (debug) debugstring+=w+'*'+m+'*'
        } else {
            // test for winding
            if (d>y && b<=y && ((x-a)*(d-b)-(y-b)*(c-a))<=0) {
                w++
            }
            if (d<y && b>=y && ((x-a)*(d-b)-(y-b)*(c-a))>=0) {
                w--
            }
            //            if (debug) debugstring+=w
            if (xa==c && ya==d) {
                xa=-1;ya=-1
                //                if (debug) debugstring+='\n'
            } else {
                //                if (debug) debugstring+='+'
            }
        }
    }
    if (w!=0) {
        contours.lastRegion=p
        contours.lastRegion.w=w
        return (p.n)
    }
    return false
}

// }}}

// Overlay Window (WINDOW CONTAINER)
// Methods: new, .update, .close, .pin, .destroy, .updateTitle
// Internal: overlayWindow.closeButton
// Globals: overlayWindow.closableWindow, overlayWindow.hideableWindow,
//          overlayWindow.hierarchicalWindow, overlayWindow.pageableWindow,
//          overlayWindow.listWindow
// {{{

function overlayWindow(uid,wm,obj,commands,title,p) {
    this.wm=wm
    this.obj=obj
    this.uid=uid
    var found=wm.slideWindow(uid)
    if (found) return true
    wm.appendWindow(this) // fills this.id
    this.idstring=this.wm.prefix+this.id
    this.title=title?title:'window'
    this.width=CELLSIZES[0]
    this.activity=1
    this.expiry=-1
    this.deathmax=1
    this.win=$('<div class="'+this.wm.prefix+'" id="'+this.wm.prefix+this.id+'"></div>').css('line-height',0)
    this.content=$('<div class="content"></div>').css('min-height',30).
        appendTo(this.win)
    this.command=$('<div class="command"></div>').css('height',this.width).
        appendTo(this.win)
    this.wtitle=$('<div class="title"><span class="inner">'+title+
                  '</span></div>').appendTo(this.win)
    wm.setXY(this.id,p,0)
    if (commands.build) {
        commands.build(this)
    }
    if (this.obj.build !== undefined) {
        this.obj.build(this)
    }
    this.win.css('width',this.width)
    this.updateTitle()
    $('body').append(this.win)
    if (this.obj.update !== undefined) {
        this.obj.update(this)
    }
    this.wm.update()
}

overlayWindow.prototype.update=function() {
    this.activity++
    if (this.obj.update) {
        this.obj.update()
    }
}

overlayWindow.prototype.close=function(force) {
    if (this.obj.close) this.obj.close(this)
    delete this.obj.owin
    delete this.obj.wm
    delete this.obj
    var wm=this.wm
    delete this.wm
    wm.removeWindow(this.id)
    this.win.removeAttr('id')
    var owin=this
    if (force) owin.destroy()
    else
        this.win.animate({opacity:0, width:0},ANIMATIONTIME,
                         function () {owin.destroy();})
}

overlayWindow.prototype.pin=function() {
    if (this.expiry < 0) {
        this.expiry=0
        this.command.find('.close img').attr('src','img/close.png')
    } else {
        this.expiry=-1
        this.command.find('.close img').attr('src','img/pinned.png')
    }
}

overlayWindow.prototype.destroy=function() {
    delete this.content
    delete this.command
    delete this.wtitle
    this.win.remove()
    delete this.win
}

overlayWindow.prototype.updateTitle=function(newTitle) {
    this.title=newTitle
    if (this.win) {
        this.wtitle.children().first().html(newTitle)
    }
}

// Different kinds of window commands

overlayWindow.closeButton=function(owin,x) {
    owin.expiry=0
    owin.deathmax=x?x:2
    owin.wm.displayer.cell('<img src="img/close.png" alt="[close]"/>').
        addClass('close').
        multiClick({},{
            simpleClick:function() {owin.close()},
            longClick:function() {owin.pin()},
        }).appendTo(owin.command)
}

overlayWindow.closableWindow={
    build:function(owin) {
        overlayWindow.closeButton(owin,2)
    }
}

overlayWindow.hideableWindow={
    build:function(owin) {
        owin.width=2*CELLSIZES[0]
        owin.hidden=true
        owin.wm.displayer.cell('<img src="img/main.png" alt="[main]"/>').
            multiClick({},{
                simpleClick: function() {
                    if (owin.hidden) {
                        owin.content.show(ANIMATIONTIME)
                        owin.hidden=false
                    } else {
                        owin.content.hide(ANIMATIONTIME)
                        owin.hidden=true
                    }
                },
                longClick: function() {windowmanagermenu.slideWindow('main')},
                doubleClick: function() {playerswindow.raise()},
                halfClick: function() {playerswindow.raise()},
            }).appendTo(owin.command).find('img').attr('id','mainimg').
            attr('src','img/'+PLAYERS[CURRENTPLAYER][1]+'.png')
        owin.content.hide()
        owin.wm.displayer.cell('<img src="img/help.png" alt="[help]"/>').
            click(function() {helpwindow.raise()}).appendTo(owin.command);
    }
}

overlayWindow.hierarchicalWindow={
    build:function(owin) {
        owin.width=4*CELLSIZES[0]
        overlayWindow.closeButton(owin,3)
        owin.wm.displayer.cell('<img src="img/left.png" alt="[left]"/>').
            click(function() {
                owin.activity++
                owin.obj.page--;owin.obj.update();}).
            addClass('previousnext').appendTo(owin.command)
        owin.wm.displayer.cell('<img src="img/right.png" alt="[right]"/>').
            click(function() {
                owin.activity++
                owin.obj.page++;owin.obj.update();}).
            addClass('previousnext').appendTo(owin.command)
        owin.wm.displayer.cell('<img src="img/up.png" alt="[up]"/>').
            click(function() {
                owin.activity++
                owin.obj.levelup();owin.obj.update();}).
            addClass('levelup').appendTo(owin.command)
    }
}

overlayWindow.pageableWindow={
    build:function(owin) {
        owin.width=3*CELLSIZES[0]
        overlayWindow.closeButton(owin,6)
        owin.wm.displayer.cell('<img src="img/left.png" alt="[left]"/>').
            click(function() {
                owin.activity++
                owin.obj.page--; owin.obj.auto=false; owin.obj.update()
            }).addClass('previous').appendTo(owin.command)
        owin.wm.displayer.cell('<img src="img/right.png" alt="[right]"/>').
            click(function() {
                owin.activity++
                owin.obj.page++; owin.obj.update();}).
            addClass('next').appendTo(owin.command)
    }
}

overlayWindow.pagesWindow={
    build:function(owin) {
        owin.width=3*CELLSIZES[0]
        overlayWindow.closeButton(owin,6)
        owin.wm.displayer.cell('<img src="img/left.png" alt="[left]"/>').
            multiClick({},{
                simpleClick: function() {
                    owin.activity++
                    owin.obj.page=-1; owin.obj.update()
                },
                longClick: function() {
                    owin.activity++
                    owin.obj.targetlist=-1; owin.obj.update()
                },
            }).addClass('previous').appendTo(owin.command)
        owin.wm.displayer.cell('<img src="img/right.png" alt="[right]"/>').
            multiClick({},{
                simpleClick: function() {
                    owin.activity++
                    owin.obj.page=1; owin.obj.update()
                },
                longClick: function() {
                    owin.activity++
                    owin.obj.targetlist=1; owin.obj.update()
                },
            }).addClass('next').appendTo(owin.command)
    }
}

overlayWindow.listWindow={
    build:function(owin) {
        owin.width=2*CELLSIZES[0]
        overlayWindow.closeButton(owin,6)
        owin.command.find('.cell').addClass('list-add')
        owin.pin()
        owin.wm.displayer.button('up').click(function() {
            owin.activity++
            owin.obj.up()
        }).addClass('list-del').hide().appendTo(owin.command)
        owin.wm.displayer.button('list-add').click(function() {
            owin.activity++
            owin.obj.add()
        }).addClass('list-add').appendTo(owin.command)
        owin.wm.displayer.button('list-del').click(function() {
            owin.activity++
            owin.obj.del()
        }).addClass('list-del').hide().appendTo(owin.command)
    }
}

// }}}

// Window Manager (WINDOW CONTAINER CONTAINER)
// Methods: new, .appendWindow, .slideWindow, .removeWindow, .getWindow,
//         .searchWindows, .destroy, .deathRow, .search
// Internals: .update, .setXY, windowManager.defaults
// {{{

function windowManager(cssClass,options,counterdisplayer) {
    this.c=[]
    this.p=[] // position of window #xxx
    this.id=[] // id of window in position #xxx
    this.prefix=cssClass
    this.displayer=counterdisplayer
    $.extend(this,windowManager.defaults,options)
}

windowManager.defaults={
    myleftmargin:10,
    mybottommargin:10,
    myintermargin:30,
    leftSide:'left',
    bottomSide:'bottom',
}

windowManager.prototype.appendWindow=function(owin) {
    for (var i=0;i<this.c.length;i++) {
        if (this.c[i]===undefined) break
    }
    // We rely on the fact that if there is no break, i=this.c.length
    this.p[i]=this.id.length
    this.id.push(i)
    this.c[i]=owin
    owin.id=i
    owin.wm=this
    owin.obj.owin=i
    owin.obj.wm=this
}

windowManager.prototype.slideWindow=function(uid) {
    // Looks for some window uid. If found, pushes window leftmost
    var found=false
    for (var i in this.c) {
        if (this.c[i].uid===uid) {
            found=true;break;
        }
    }
    if (found) {
        for (var j=this.p[i];j>0;j--) {
            this.id[j]=this.id[j-1]
            this.p[this.id[j]]=j
        }
        this.id[0]=i
        this.p[i]=0
        this.c[i].activity++
    }
    this.update()
    return found
}

windowManager.prototype.removeWindow=function(d) {
    if (this.c[d]!==undefined) {
        delete this.c[d]
    }
    if (this.p[d]!==undefined) {
        var p=this.p[d]
        delete this.p[d]
        for (var i=p;i<this.id.length-1;i++) {
            this.id[i]=this.id[i+1]
            this.p[this.id[i]]=i
        }
        this.id.pop()
    }
    this.update()
}

windowManager.getWindow=function(x) {
    // Returns window stored in object by owin/wm couple
    // No assertions
    if (x.wm === undefined || x.owin === undefined) return undefined
    return (x.wm.c[x.owin])
}

windowManager.prototype.searchWindows=function(type) {
    // returns all windows matching some type
    // No assertions
    var res=[]
    for (var i=0;i<this.c.length;i++) {
        if (this.c[i]==undefined) continue
        if (this.c[i].obj.type === type)
            res.push(this.c[i])
    }
    return res
}
windowManager.prototype.destroy=function() {
    for (var i=0;i<this.c.length;i++) {
        if (this.c[i]==undefined) continue
        this.c[i].close(true)
    }
    delete this.c
    delete this.id
    delete this.p
    delete this.leftSide
    delete this.mybottommargin
    delete this.myintermargin
    delete this.myleftmargin
    delete this.prefix
}

windowManager.prototype.deathRow=function() {
    for (var i=0;i<this.c.length;i++) {
        if (this.c[i]===undefined) continue
        var owin=this.c[i]
        if (owin.expiry<0) continue
        if (owin.activity>0) {
            owin.activity=0
            owin.expiry=0
        } else {
            owin.expiry++
        }
        // During drag and drop, do nothing
        if (context.context==1) continue
        if (owin.expiry>=owin.deathmax)
            owin.close()
    }
}

windowManager.prototype.search=function(x,y) {
    var xpos
    var ypos
    if (this.leftSide=='right') {
        xpos=windowwidth-x
    } else {
        xpos=x
    }
    if (this.bottomSide=='bottom') {
        ypos=windowheight-y
    } else {
        ypos=y
    }
    var left=this.myleftmargin
    var bottom=this.mybottommargin
    if (xpos<left) return undefined
    if (ypos<bottom) return undefined
    for (var i=0;i<this.id.length;i++) {
        var id=this.id[i]
        var owin=this.c[id]
        left+=this.myintermargin+this.c[id].width
        if (xpos<left) {
            // found
            var h=owin.content.height()
            var hh=owin.command.height()
            if (ypos<hh+bottom) return undefined
            if (ypos<hh+h+bottom) return owin
            return undefined
        }
    }
    return undefined
}

windowManager.prototype.update=function() {
    var left=this.myleftmargin
    for (var i=0;i<this.id.length;i++) {
        var id=this.id[i]
        var owin=this.c[id]
        var style={width: owin.width}
        // TODO: we may want guided height, too, eg in hierarchical windows
        // if (owin.height!==undefined) style.height=owin.height
        style[this.bottomSide]=this.mybottommargin
        style[this.leftSide]=left
        owin.win.animate(style,ANIMATIONTIME,undefined)
        left+=this.myintermargin+this.c[id].width
    }
}

windowManager.prototype.setXY=function(id,startPosition,width) {
    var xpos
    var ypos
    if (!startPosition) {
        xpos=windowwidth/2
        ypos=windowheight/2
    } else {
        if (this.leftSide=='right') {
            xpos=windowwidth-startPosition.x
        } else {
            xpos=startPosition.x
        }
        if (this.bottomSide=='bottom') {
            ypos=windowheight-startPosition.y
        } else {
            ypos=startPosition.y
        }
    }
    var t={position:'absolute'}
    if (width!==undefined) t.width=width
    t[this.leftSide]=xpos
    t[this.bottomSide]=ypos
    this.c[id].win.css(t)
}

// }}}


// Main menu (WINDOW CONTENT)
// Methods: new, .build, .raise
// {{{

function mainMenu() {
    this.type=MAINMENUTYPE
}
mainMenu.prototype.build=function(owin) {
    owin.content.css('min-height','')
    owin.wm.displayer.button('map','Stored locations').appendTo(owin.content).
        click(function () {locationstorage.raise()})
    owin.wm.displayer.button('search','Stack overview').appendTo(owin.content).
        click(function () {stackoverview.raise()})
    owin.wm.displayer.button('drop','Counters Box').appendTo(owin.content).
        click(function() {new picker(counters,[]).raise()})
    owin.wm.displayer.button('zoom-in','Zoom functions').appendTo(owin.content).
        click(function() {zoomwindow.raise()})
    owin.wm.displayer.button('messages','Messages').appendTo(owin.content).
        click(function() {orderstorage.raise()})
}

mainMenu.prototype.raise=function() {
    new overlayWindow('main',windowmanagermenu,this,
                      overlayWindow.hideableWindow,'Menu')
}

map_hooks['mainmenu']=function() {mainmenu.raise()}

// }}}

// locationStorage (WINDOW CONTENT)
// Methods: new, .build, .update, .close, .raise
// Internal: .panTo, .select, .add, .del, .up
// Globals: locationstorage
// {{{

locationStorage=function() {
    this.l=[]
    this.type=LOCATIONTYPE
}

locationStorage.prototype.build=function(owin) {
    owin.width=2*CELLSIZES[0]
}

locationStorage.prototype.update=function() {
    var owin=this.wm.c[this.owin]
    owin.content.empty()
    var t=this
    var h=function(k,a) {return function() {t[a](k)}}
    var pending=false
    var cssdefaults={
        width:owin.width,
        lineHeight:'100%',
        height:20,
        textAlign:'center',
    }
    for (var i in this.l) {
        if (this.l[i]) {
            $('<div>'+this.l[i].n+'</div>').
                css(cssdefaults).
                addClass('location'+(this.l[i].s?'-selected':'')).
                multiClick({},{
                    simpleClick:h(i,'panTo'),
                    longClick:h(i,'select'),
                    doubleClick:h(i,'up'),
                    halfClick:h(i,'del')
                }).appendTo(owin.content)
            if (this.l[i].s) pending=true
        }
    }
    var a=$('<div>'+contours.xyc+'</div>').
        css(cssdefaults).
        addClass('location-current').
        appendTo(owin.content)
    contours.xyc_=a.get(0)
    var a=$('<div>'+contours.xyn+'</div>').
        css(cssdefaults).
        addClass('location-current').
        appendTo(owin.content)
    contours.xy_=a.get(0)
    var a=$('<div>'+contours.xyn+'</div>').
        css(cssdefaults).
        addClass('location-current').
        appendTo(owin.content)
    contours.xyn_=a.get(0)
    contours.updateCoordinates()
    if (pending) {
        owin.command.find('.list-add').hide()
        owin.command.find('.list-del').show()
    } else {
        owin.command.find('.list-del').hide()
        owin.command.find('.list-add').show()
    }
}

locationStorage.prototype.close=function(owin) {
    delete contours.xy_
    delete contours.xyn_
    delete contours.xyc_
}

locationStorage.prototype.raise=function() {
    new overlayWindow('locationstorage',windowmanagermenu,this,
                      overlayWindow.listWindow,'Locations')
}

locationStorage.prototype.panTo=function(i) {
    var owin
    owin=windowManager.getWindow(this)
    owin.activity++
    map.panTo(this.l[i].p)
}

locationStorage.prototype.select=function(i) {
    owin=windowManager.getWindow(this)
    owin.activity++
    this.l[i].s=!(this.l[i].s)
    this.update()
}

locationStorage.prototype.add=function() {
    var p=map.getCenter()
    var i=this.l.length
    this.l[i]={p:p,n:contours.transformCoordLocation(p),s:false}
    this.update()
}

locationStorage.prototype.del=function(x) {
    if (x===undefined) {
        for (var i in this.l) {
            if (this.l[i] && this.l[i].s) {
                delete this.l[i]
            }
        }
    } else {
        delete this.l[x]
    }
    this.update()
}

locationStorage.prototype.up=function(x) {
    var nl=[]
    if (x!==undefined) {
        nl.push(this.l[x])
        for (var i in this.l) {
            if (i!=x) {
                nl.push(this.l[i])
            }
        }
    } else {
        for (var i in this.l) {
            if (this.l[i] && this.l[i].s) {
                nl.push(this.l[i])
            }
        }
        for (var i in this.l) {
            if (this.l[i] && !this.l[i].s) {
                nl.push(this.l[i])
            } else {
                if (this.l[i])
                    this.l[i].s=false
            }
        }
    }
    this.l=nl
    this.update()
}

locationstorage=new locationStorage()

// }}}

// Stack Overview (WINDOW CONTENT)
// Methods: new, .build, .raise
// Internal:
// Globals: stackoverview
// {{{

stackOverview=function() {
    this.type=SEARCHTYPE
}
stackOverview.prototype.build=function(owin) {
}
stackOverview.prototype.update=function() {
    var owin=windowManager.getWindow(this)
    if (!owin) return
}
stackOverview.prototype.raise=function() {
    new overlayWindow('stackoverview',windowmanagermenu,
                      this,overlayWindow.hierarchicalWindow,
                      'Stacks')
}
stackoverview=new stackOverview()

// }}}

// Zoom window (WINDOW CONTENT)
// Methods: new, .build, .raise
// Internals: .activity, .zoom{Out,Std,In}{Map,Markers}
// Globals: zoomwindow
// {{{

zoomWindow=function() {
    this.type=ZOOMTYPE
}

zoomWindow.prototype.build=function(owin) {
    owin.wm.displayer.button('zoom-in','No zoom').appendTo(owin.content).
        multiClick({},{
            simpleClick:zoomWindow.zoomInMap,
            longClick:zoomWindow.zoomInMarkers
        })
    owin.wm.displayer.button('zoom-original','No zoom').appendTo(owin.content).
        multiClick({},{
            simpleClick:zoomWindow.zoomStdMap,
            longClick:zoomWindow.zoomStdMarkers
        })
    owin.wm.displayer.button('zoom-out','No zoom').appendTo(owin.content).
        multiClick({},{
            simpleClick:zoomWindow.zoomOutMap,
            longClick:zoomWindow.zoomOutMarkers
        })
    owin.obj.wm=owin.wm
    owin.obj.owin=owin.id
}

zoomWindow.prototype.raise=function() {
    new overlayWindow('zoomwindow',windowmanagermenu,
                      this,overlayWindow.closableWindow,
                      'Zoom')
}

zoomWindow.prototype.activity=function() {
    owin=windowManager.getWindow(this)
    if (owin) {
        owin.activity++
    }
}

zoomWindow.zoomOutMap=function() {
    zoomwindow.activity()
    map.setZoom(map.getZoom()-1)
}
zoomWindow.zoomStdMap=function() {
    zoomwindow.activity()
    map.setZoom(ZOOMOFFSET+5)
}
zoomWindow.zoomInMap=function() {
    zoomwindow.activity()
    map.setZoom(map.getZoom()+1)
}
zoomWindow.zoomInMarkers=function() {
    zoomwindow.activity()
    MARKERDELTA++
    stacks.updateViewMap()
}
zoomWindow.zoomStdMarkers=function() {
    zoomwindow.activity()
    MARKERDELTA=0
    stacks.updateViewMap()
}
zoomWindow.zoomOutMarkers=function() {
    zoomwindow.activity()
    MARKERDELTA--
    stacks.updateViewMap()
}

zoomwindow=new zoomWindow()

// }}}

// Help window (WINDOW CONTENT)
// Methods: new, .build, .update, .raise
// Globals: helpwindow
// {{{

helpWindow=function(a) {
    this.type=HELPTYPE
    this.m=a
}

helpWindow.prototype.build=function(owin) {
    this.owin=owin.id
    this.wm=owin.wm
    this.page=0
    var s=CELLSIZES[0]
    owin.width=3*s
    $('<div class="help" id="helppage" />').css({
        display:'block',
        overflow:'auto',
        minHeight: 30,
        lineHeight:1,
        fontSize:12,
        color:'white',
    }).appendTo(owin.content)
}

helpWindow.prototype.update=function() {
    owin=windowManager.getWindow(this)
    var owin=windowManager.getWindow(this)
    if (owin===undefined) return
    var page=this.page
    var l=this.m.length-1
    if (page>=l)
        page=l
    if (page==l) {
        owin.command.find('.next').css('opacity',.3)
    } else {
        owin.command.find('.next').css('opacity',1)
    }
    if (page<=0) {
        page=0
        owin.command.find('.previous').css('opacity',.3)
    } else {
        owin.command.find('.previous').css('opacity',1)
    }
    this.page=page
    $('#helppage').html(this.m[page])
}

helpWindow.prototype.raise=function() {
    new overlayWindow('helpwindow',windowmanagermenu,this,
                      overlayWindow.pageableWindow,'Help')
}

helpwindow=new helpWindow([
    '<em>Soon, your help file here</em>',
    'A second page<br/>A second page<br/>A second page<br/>A second page<br/>A second page<br/>A second page<br/>',
])

// }}}

// Players (WINDOW CONTENT)
// Methods: new, .build, .update, .raise
// Internal: .append , .choose
// Globals: playerswindow, CURRENTPLAYER
// {{{

playersWindow=function (p) {
    this.m=p
    this.page=0
    this.type=PLAYERSTYPE
}

playersWindow.prototype.build=function(owin) {
    this.owin=owin.id
    this.wm=owin.wm
    var s=CELLSIZES[0]
    owin.content.css({
        width: 3*s,
        height: 4*s,
    })
    for (var i=0;i<4;i++) {
        function j(t,x) {return function() {t.choose(x)}}
        var k=$('<div class="ic" id="plyic'+i+'"></div>').css({
            display:'block',
            position: 'absolute',
            top:i*s,
            left:0,
            height:s,
            width:s,
            overflow:'hidden',
            lineHeight:1,
            fontSize:12,
        }).appendTo(owin.content).
            click(j(this,i))
        k=$('<div class="co" id="plyco'+i+'"></div>').css({
            display:'block',
            position: 'absolute',
            top:i*s,
            left:s,
            height:s,
            width:2*s,
            overflow:'hidden',
            lineHeight:1,
            textAlign:'center',
            fontSize:20,
            color:'white',
        }).appendTo(owin.content).
            click(j(this,i))
    }
}

playersWindow.prototype.update=function() {
    var owin=windowManager.getWindow(this)
    if (owin===undefined) return
    var page=this.page
    var l=this.m.length-1
    var ll=Math.ceil(l/4)
    page=(ll+page)%ll
    if (ll>1) {
        owin.command.find('.previous').css('opacity',1)
        owin.command.find('.next').css('opacity',1)
    } else {
        owin.command.find('.next').css('opacity',.3)
        owin.command.find('.previous').css('opacity',.3)
    }
    this.page=page
    for (var i=0;i<4;i++) {
        var mm=this.m[page*4+i]
        var k=owin.content.find('#plyco'+i).empty().
            html('<span class="text">'+mm[0]+'</span>')
        if (CURRENTPLAYER==page*4+i) {
            k.addClass('playerSelected')
        } else {
            k.removeClass('playerSelected')
        }
        var k=owin.content.find('#plyic'+i).empty().append('<img src="img/'+mm[1]+'.png" alt="'+mm[0]+'">')
    }
}

playersWindow.prototype.choose=function(x) {
    CURRENTPLAYER=this.page*4+x
    $('#mainimg').attr('src','img/'+PLAYERS[CURRENTPLAYER][1]+'.png')
    var owin=windowManager.getWindow(this)
    if (owin) owin.update()
}

playersWindow.prototype.raise=function() {
    new overlayWindow('players',windowmanagermenu,
                      this,overlayWindow.pageableWindow,'Change player')
}

playerswindow=new playersWindow(PLAYERS)

// }}}

// Orders (WINDOW CONTENT)
// Methods: new, .build, .update, .raise, .append, .remove
// Internal:
// Globals: orderstorage, 
// {{{

// Each order stored is an order identified by x.i
// It must have x.mt (title), x.mm (message), x.mi (icon) set
orderStorage=function () {
    this.orders={}
    this.m=[]
    this.c=[0,0,0]
    this.auto=[]
    this.listtitles=['Orders','Pending','Cancelled']
    for (var i in this.listtitles) {
        this.m[i]=[]
        this.auto[i]=true
    }
    this.page=0
    this.type=MSGTYPE    
    this.list=0
    this.targetlist=0
}

orderStorage.prototype.build=function(owin) {
    this.owin=owin.id
    this.wm=owin.wm
    var t=this;
    var s=CELLSIZES[0]
    owin.content.css({
        width: 3*s,
        height: 4*s+20,
        position:'relative',
    })
    var kk=$('<div id="msgbox"/>').css({
        width: 3*s,
        height: 3*s+20,
        overflow:'hidden',
        position:'relative',
    }).appendTo(owin.content)
    for (var j in this.listtitles) {
        $('<div id="ordertitle'+j+'" class="msgtitle" />').css({
            width: 3*s,
            height: 20,
            position: 'absolute',
            top:0,
            left:j*3*s,
            backgroundColor: 'black',
            color: 'white',
            fontSize: 12,
            lineHeight:1,
            textAlign: 'center'
        }).appendTo(kk)
        var k=$('<div id="orderbox'+j+'" class="msglist" />').css({
            width: 3*s,
            height: 3*s,
            overflow: 'auto',
            position: 'absolute',
            top:20,
            left:j*3*s,
            backgroundColor: 'rgba(255,255,255,.5)',
        }).appendTo(kk)
        for (var i in this.m[j]) {
            this.msgline(j,i).appendTo(k)
        }
    }
    k=$('<form class="msgsend" />').css({
        display:'block',
        position: 'absolute',
        top:3*s+20,
        left:0,
        height:s,
        width:3*s,
        textAlign:'center',
        overflow:'hidden',
        lineHeight:1,
        fontSize:14,
    }).appendTo(owin.content)
    $('<textarea id="msgsend" />').css({
        height:s-37,
        width:3*s-10,
        position: 'absolute',
        top: 0,
        left: 0,
        padding: 4,
        border: '1px solid black',
        backgroundColor: 'white',
        resize: 'none',
    }).click(function(){this.focus()}).
        change(function() {owin.activity++}).
        appendTo(k)
    $('<div class="button">Send!</div>').css({
        width:1.5*s-11,
        left: 0,
        marginRight:2,
    }).click(function(){t.send()}).
        appendTo(k)
    $('<div class="button">Clear</div>').css({
        width:1.5*s-11,
        right: 0,
        marginLeft:2,
    }).click(function(){$('#msgsend').val('')}).
        appendTo(k)
}

orderStorage.prototype.msgline=function(l,i) {
    var s=CELLSIZES[0]
    var mm=this.m[l][i]
    var k=$('<div class="msgline" />').css({
        height: s,
        width: 2*s-20,
        position:'absolute',
        top: i*s,
        left: s,
        lineHeight: 1,
    }).html('<div class="date"><b>'+mm.mt+
            '</b></div><span class="text">'+mm.mm+'</span>').
        attr('id','msgline_'+l+'_'+mm.i)
    var kk=$('<div class="msgic" />').css({
        height: s,width: s,position:'absolute',left:-s,top:0
    }).appendTo(k)
    this.wm.displayer.cell('<img src="'+mm.mi+'" />',mm.ms,mm.ms).appendTo(kk)
    return k
}

orderStorage.prototype.send=function() {
    var k=$('#msgsend');
    if (k && k.val()) {
        ordermanager.ooqueue({
            t: OMO.MESSAGE,
            q: CURRENTPLAYER,
            s: $('#msgsend').val(),
            mt: PLAYERS[CURRENTPLAYER][2]+' says',
            mm: $('#msgsend').val(),
            mi: 'img/'+PLAYERS[CURRENTPLAYER][1]+'.png',
            ms: CELLSIZES[0],
        })
        k.val('');
    }
}

orderStorage.prototype.update=function() {
    var owin=windowManager.getWindow(this)
    if (owin===undefined) return
    owin.activity++
    var s=CELLSIZES[0]
    var page=this.page
    this.page=0
    var targetlist=this.targetlist
    this.targetlist=0
    for (var i in this.listtitles) {
        var k=''
        for (var j in this.listtitles) {
            if (j!=i) {
                k=k+'['+this.c[j]+']'
            } else {
                k=k+'['+this.listtitles[i]+': '+this.c[i]+']'
            }
        }
        $('#ordertitle'+i).html(k)
    }
    if (targetlist) {
        this.list+=targetlist
        if (this.list>2) this.list=0
        if (this.list<0) this.list=2
        $('#msgbox').animate({scrollLeft:3*s*this.list},ANIMATIONTIME)
    }
    var k=$('#orderbox'+this.list)
    var kk=k.get(0)
    var st=kk.scrollTop
    var sti=kk.scrollHeight-3*s
    if (page<0) this.auto[this.list]=false
    if (page>0 && st>=sti-s) {
        this.auto[this.list]=true
    }
    st-=st%80
    st+=page*s
    if (this.auto[this.list]) {
        owin.command.find('.next').css('opacity',.3)
        st=sti
    } else {
        owin.command.find('.next').css('opacity',1)
    }
    k.animate({scrollTop:st},ANIMATIONTIME/4)
}

orderStorage.prototype.raise=function() {
    new overlayWindow('orders',windowmanagermenu,
                      this,overlayWindow.pagesWindow,'Orders')
}

orderStorage.prototype.append=function(b,a) {
    var l=this.m[b].length
    this.m[b].push(a)
    this.c[b]++
    var k=$('#orderbox'+b)
    if (k.length>0)
        k.append(this.msgline(b,l))
    this.update()
    return l
}

orderStorage.prototype.remove=function(b,a) {
    var mm=this.m[b]
    for (var i in mm) {
        if (mm[i].i==a.i) {
            delete mm[i]
            this.c[b]--
        }
    }
    $('#msgline_'+b+'_'+a.i).remove()
    this.update()
}

orderstorage=new orderStorage()

// }}}

// Stacks zoom management (WINDOW CONTENT)
// Useful globals:
// Methods: new, .build, .update, .close
// Internal: .askNick, stackZoom.changeNick
// Globals: stackZoom.raise
// {{{

// A stackZoom is attached to its stack by window id+wm
function stackZoom(i) {
    this.type=STACKZOOMTYPE
    this.stacknumber=i
}

stackZoom.prototype.build=function(owin) {
    var s=stacks.s[this.stacknumber]
    this.owin=owin.id
    this.wm=owin.wm
    var oldwin=windowManager.getWindow(s)
    if (oldwin) {
        oldwin.close()
    }
    owin.win.click(function() {owin.activity++})
    s.owin=owin.id
    s.wm=owin.wm
    this.update()
    var t=this
    owin.wtitle.multiClick({},{
        simpleClick:function() {t.askNick()},
        longClick: function() {map.panTo(s.position)},
    })
}

stackZoom.prototype.update=function() {
    var owin=windowManager.getWindow(this)
    var a
    var b=owin.content
    var s=stacks.s[this.stacknumber]
    b.empty()
    for (i=s.content.length-1;i>=0;i--) {
        var data={wm:this.wm,owin:this.owin,
                  counter:s.content[i],stack:this.stacknumber,rank:i}
        owin.wm.displayer.repr(s.content[i],data).appendTo(b)
    }
    owin.updateTitle(s.nick?(s.nick+' / '+s.region):s.region)
}

stackZoom.prototype.close=function(owin) {
    var s=stacks.s[this.stacknumber]
    delete s.owin
    delete s.wm
    if (s.content && s.content.length==0 && !s.preserve) {
        ordermanager.ooqueue({
            t: OMO.DELETESTACK,
            a: this.stacknumber,
            mt: 'Stack dissolved',
            mm: 'This stack is dissolved',
            mi: 'img/delstack.png',
            ms: CELLSIZES[0]
        })
    }
}

stackZoom.changeNick=function() {
    ordermanager.ooqueue({
        t: OMO.RENAMESTACK,
        s: modal.value,
        a: modal.key,
        mi: 'img/text.png',
        ms: CELLSIZES[0],
        mt: 'Stack renamed',
        mm: 'This stack was renamed to '+modal.value+'.'
    })
}

stackZoom.prototype.askNick=function() {
    modal.key=this.stacknumber
    modal.ask('Change name of this stack',stackZoom.changeNick)
}

stackZoom.raise=function(x) {
    assert(stacks.s[x]!==undefined,'Stack #'+x+' is undefined')
    new overlayWindow(
        'stack'+x,windowmanager,
        new stackZoom(x),overlayWindow.closableWindow,'',
        projection.fromLatLngToPixel(map,stacks.s[x].position))
}

// }}}

// Picker management (WINDOW CONTENT)
// Methods: new, .build, .update, .close, .raise
// Internal: .updatePath, .levelUp, .cut, .button, .children, .recChildren
//           .getNode
// Globals: picker.sortElements
// {{{

function picker(c,p) {
    this.c=c
    this.p=p
    this.page=0
    this.limit=15
    this.type=PICKERTYPE
}

picker.prototype.build=function(owin) {
    owin.content.css({
        width: 4*CELLSIZES[0],
        height: 4*CELLSIZES[0],
    })
    this.owin=owin.id
    this.wm=owin.wm
    this.counterdisplayer=this.wm.displayer
    this.update()
}

picker.prototype.update=function() {
    var treenode=this.getNode()
    var elts=this.recChildren(treenode)
    if (elts.length==1 && this.p.length > 0) {
        return this.levelup()
    }
    var cpath=treenode._path.length
    if (cpath != this.p.length) {
        return this.updatePath(treenode._path)
    }
    var owin=windowManager.getWindow(this)
    var limit=this.limit
    var cl=owin.content
    cl.children().remove()
    if (this.page*limit > elts.length) {
        this.page=0
    }
    if (elts.length<=limit) owin.win.find('.previousnext').css('opacity','.3')
    else owin.win.find('.previousnext').css('opacity','1')
    if (this.page <0) this.page=Math.floor(elts.length/limit)
    var e=elts.slice(this.page*limit,(this.page+1)*limit)
    for (var i=0;i<e.length;i++) {
        if (typeof(e[i])=='number') {
            var data={wm: this.wm, owin: this.owin,
                      counter: e[i], stack: 'box',rank:0}
            var a=this.counterdisplayer.repr(e[i],data)
            a.appendTo(cl)
        } else {
            var a=this.button(e[i],cpath)
            var k=e[i]._path.slice()
            function pickerHelper(t,k) {
                return function() {t.updatePath(k);}
            }
            a.click(pickerHelper(this,k)).appendTo(cl)
        }
    }
    if (this.p.length) {
        owin.updateTitle(this.p.map(this.cut).join(' / '))
        owin.win.find('.levelup').css('opacity',1)
    } else {
        owin.updateTitle('Box')
        owin.win.find('.levelup').css('opacity','.3')
    }
}

picker.prototype.close=function() {
    delete this.c
    delete this.p
}

picker.prototype.raise=function() {
    new overlayWindow('Box',windowmanager,this,
                      overlayWindow.hierarchicalWindow,'Box')
}

picker.prototype.updatePath=function(p) {
    this.p=p.slice()
    this.update()
}

picker.prototype.levelup=function(path) {
    var p
    var n=[]
    if (path==undefined) p=this.p
    else p=path
    var here=this.c.tree
    var pl=p.length
    for (var i=0;i<p.length;i++) {
        n.push(here._count)
        here=here[p[i]]
    }
    i=here._count
    for (var j=n.length-1;j>=0;j--) {
        if (n[j]>i) break
    }
    var xp
    if (path==undefined)
        if (j==-1) xp=[]
    else xp=p.slice(0,j)
    if (path===undefined)
        this.updatePath(xp)
    else
        return xp
}

picker.prototype.cut=function(mm) {
    var mmm=mm.indexOf('~')
    if (mmm !=-1) {
        mm=mm.substring(mmm+1)
    }
    return mm
}

picker.prototype.button=function(o,l) {
    var pp=o._path.slice(l)
    pp.sort()
    var oname=this.cut(pp[0])
    var a=this.counterdisplayer.cell('<img title="'+oname+'" src="img/menu/menu_'+oname+'.png" alt="'+oname+'" />')
    return(a)
}

picker.prototype.children=function(here) {
    var elts=[]
    for(var i in here) {
        if (i=='_count') continue
        if (i=='_path') continue
        if (typeof(here[i])=='object' && here[i]._count>0) {
            elts.push(here[i])
        } else if (typeof(here[i])!='object' &&
                   this.c.s[here[i]].stack===undefined) {
            elts.push(here[i])
        }
    }
    return elts
}

picker.prototype.recChildren=function(here) {
    var elts=this.children(here)
    var kids
    var moved
    elts.sort(picker.sortElements)
    for(var i in elts) {
        if (typeof(elts[i])=='object') {
            moved=elts[i]
            delete kids
            do {
                kids=this.children(moved)
                if (kids.length==1) moved=kids[0]
            } while (kids.length==1)
            if (moved!==elts[i]) {
                elts[i]=moved
            }
        }
    }
    return elts
}

picker.prototype.getNode=function(path) {
    var p
    if (path===undefined) p=this.p
    else p=path
    var here=this.c.tree
    for (i=0;i<p.length;i++) {
        if (here[p[i]]!==undefined) {
            here=here[p[i]]
        }
    }
    return here
}

picker.sortElements=function(a,b) {
    var aa=(typeof(a)=='number')
    var bb=(typeof(b)=='number')
    if (aa && bb) return(a-b)
    if (aa && !bb) return(1)
    if (!aa && bb) return(-1)
    for (var i=0;i<a._path.length;i++) {
        if (a._path[i]>b._path[i]) return 1
        if (a._path[i]<b._path[i]) return -1
    }
    return 0
}

// }}}

$(function() {
    server.getId(server.gameReboot)
})
