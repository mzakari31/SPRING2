module SPRING2
    using Plots

    export SpringParam,InitParam,AnimParam
    export animate_spring

    Base.@kwdef struct SpringParam
        ls::Float64 # Spring length
        ms::Float64 # Mass
        ks::Float64 # Rigidity
        ns::Int     # Mass number
    end
    getvalues(p::SpringParam) = p.ls,p.ms,p.ks,p.ns

    Base.@kwdef struct InitParam
        λ::Float64      # wavelength of initial deformation
        shift::Float64  # Maximal initial mode displacement
        pos::Float64    # Central position of the node displacement
    end
    getvalues(p::InitParam) = p.λ,p.shift,p.pos

    Base.@kwdef struct AnimParam #Base.@kwdef:allow define fields by name
        δt::Float64         # Time step
        nδt::Int            # Number of timesteps
        nδtperframe::Int    # Number of timesteps per animation frame
    end
    getvalues(p::AnimParam) = p.δt,p.nδt,p.nδtperframe

    steady_position(i,ls) = (i-1)*ls

    function initial_position(i,ls,λ,shift,pos)
        xs = steady_position(i,ls)
        dx = xs - pos
        xs-λ*dx*shift*exp(-0.5*dx^2/λ^2)
    end

    function update_force!(fx,xc,ks)
        ns= length(xc)
        for i ∈ 2:ns-1
            fx[i] = -ks*(2xc[i]-xc[i-1]-xc[i+1])
        end
    end

# Integration de Verlet
    function update_position!(xt,xc,xp,fx,δt,ms)
        coef=δt^2/ms
        @. xt=2xc-xp+fx*coef
    end

    function advance_nδtpf(xc,xp,xt,fx,sp,ap)
        ls,ms,ks,ns = getvalues(sp)
        δt,nδt,nδtperframe = getvalues(ap)

        for _ ∈ 1:nδtperframe
            update_force!(fx,xc,ks)
            update_position!(xt,xc,xp,fx,δt,ms)
            xc,xp,xt=xt,xc,xp
        end
        xc,xp,xt
    end

    function animate_spring(sp,ip,ap)
        ls,ms,ks,ns = getvalues(sp)
        λ,shift,pos = getvalues(ip)
        δt,nδt,nδtperframe = getvalues(ap)

        xs=[steady_position(i,ls) for i ∈ 1:ns]
        xc=[initial_position(i,ls,λ,shift,pos) for i ∈ 1:ns]

        dc=zero(xc)
        @. dc = xc - xs
        mdc=maximum(dc)

        # plot(xs,dc)
        fx=zero(xc)
        update_force!(fx,xc,ks)
        # plot(xs,fx)

        xt=zero(xc)
        xp=copy(xc)

        nf=nδt ÷  nδtperframe
        t=0.0
        anim= @animate for i ∈ 1:nf
            xc,xp,xt=advance_nδtpf(xc,xp,xt,fx,sp,ap)
            @. dc = xc - xs
            t+=nδtperframe*δt
            plot(xs,dc,ylims=(-mdc,mdc),title="t=$t")
        end
        gif(anim,"toto.gif",fps=15)
    end
end # module
