var http,url,path,fs,port,counters,exec,querystring
counters=require('../counters.js')
exec = require('child_process').exec
http=require('http')
url=require('url')
querystring=require('querystring')
path=require('path')
fs=require('fs')
port=process.argv[2] || 8888

function Merger() {
    var i,j
    this.s={}
    this.c={}
    this.n={}
    this.p={}
    this.cl=0
    this.convert='/usr/bin/convert'
    for (i in counters.counters) {
        if (counters.counters.hasOwnProperty(i)) {
            j=counters.counters[i]
            this.s[i]={s:j.a.side.m,f:j.f,b:j.b}
        }
    }
    this.l=[
        [undefined,undefined,7,13,25,50,100,200,400],
        [undefined,undefined,8,16,32,63,125,250,500],
        [undefined,undefined,8,16,32,63,125,250,500]
    ]
}
Merger.prototype.cache=function(t,g) {
    var i
    this.n[t]=g
    delete this.p[g]
    if (this.c[g]===undefined) {
        this.cl++
    }
    this.c[g]=(new Date).getTime()
    if (this.cl<300) return
    for (i in this.c) {
        if (this.c.hasOwnProperty(i)) {
            // Examine age
            continue
            // delete if necessary
            this.cl--
            delete this.c[i]
            if (this.cl<150) break
        }
    }
}
Merger.prototype.filename=function(n,s,z) {
    var CS,m,P
    var CS=[[''],['_recto','_verso']]
    var m=merger.s[n]
    if (m===undefined) return -1
    P='./pions/bitmap/counter_'+z+'/'+m.f+CS[m.s][s]+'.png'
    return(P)
}
Merger.prototype.command=function(t,response,x) {
    var FS,z,a,b,c,d,e,f,g,h,i,self
    if (this.n[t]) {
        return this.n[t]
    }
    a=t.split('.')
    if (a.length<3) throw('Incorrect merge syntax')
    z=Math.floor(Number(a[0]))
    if (z<2||z>8) throw('Incorrect merge zoom')
    e=-1
    f=[]
    i=[z]
    for (b=a.length-2;b>0;b--) {
        c=a[b].charCodeAt(0)-65
        d=parseInt(a[b].substr(1),10)
        if (this.s[d].b>e) {
            f.push(this.filename(d,c,z))
            i.unshift(a[b])
            e=this.s[d].b
        }
    }
    h=[this.convert]
    h.push('-gravity center ./web/server/black_'+this.l[e][z]+'.png')
    for (b=f.length-1;b>=0;b--) {
        h.push(f[b])
        h.push('-composite')
    }
    i.push('png')
    g=i.join('.')
    self=this
    if (this.p[g] && x<10) {
        setTimeout(function() {self.command(t,response,x+1)},500)
    }
    h.push('./web/c/'+g)
    exec(h.join(' '),function(error,stdout,stderr) {
        if (error !== null) {
            response.writeHead(500, {"Content-Type": "text/plain"})
            response.write("Error generating the image\n")
            response.end()
            return
        }
        self.cache(t,g)
        sendFile(response,'./web/c/'+g)
    })
    return this.n[t]
}

var merger=new Merger()

function sendFile(response,filename) {
    fs.readFile(filename, "binary", function(err, file) {
        if(err) {
            response.writeHead(500, {"Content-Type": "text/plain"})
            response.write(err + "\n")
            response.end()
            return
        }
        response.writeHead(200)
        response.write(file, "binary")
        response.end()
    })
}

http.createServer(function(request, response) {
    var u,uri,filename
    u=url.parse(request.url,true)
    uri=u.pathname
    if (uri.match('/merge.php')&& u.query) {
        merger.command(u.query.f,response,0)
    } else {
        filename=path.join(process.cwd(), uri)
        path.exists(filename, function(exists) {
            if(!exists) {
                response.writeHead(404, {"Content-Type": "text/plain"})
                response.write("404 Not Found\n")
                response.end()
                return
            }
            if (fs.statSync(filename).isDirectory()) filename += '/index.html'
            sendFile(response,filename)
        })
    }
}).listen(parseInt(port, 10))

console.log(process.cwd())
