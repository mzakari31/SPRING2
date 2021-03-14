push!(LOAD_PATH,joinpath(@__DIR__, ".."))
using Documenter, SPRING2

makedocs(
    modules = [SPRING2],
    format = Documenter.HTML(; prettyurls = get(ENV, "CI", nothing) == "true"),
    authors = "mustapha zakari",
    sitename = "SPRING2.jl",
    pages = Any["index.md"]
    # strict = true,
    # clean = true,
    # checkdocs = :exports,
)

deploydocs(
    repo = "github.com//SPRING2.jl.git",
)
