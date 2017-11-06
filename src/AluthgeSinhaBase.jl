module AluthgeSinhaBase

# abstract types to export:
export AbstractDataset,
    AbstractTabularDataset,
    AbstractHoldoutTabularDataset

include("abstracttypes.jl")
include("fakedata.jl")
include("formulas.jl")
include("labelcoding.jl")
include("tabulardatasets.jl")
include("util.jl")
include("version.jl")

end # module
