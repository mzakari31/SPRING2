using SPRING2
sp = SpringParam(ls=0.1,ms=1,ks=1,ns=1000)
ip = InitParam(λ=1.0,shift=1.5,pos=sp.ls*sp.ns/2)
ap = AnimParam(δt=1.0,nδt=2000,nδtperframe=10)

animate_spring(sp,ip,ap)