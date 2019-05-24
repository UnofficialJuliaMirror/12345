import Pkg; 

Pkg.Registry.add(Pkg.RegistrySpec(name="BCBIRegistry",url="https://github.com/bcbi/BCBIRegistry.git",uuid="26a550a3-39fe-4af4-af6d-e8814c2b6dd9",)); 
Pkg.Registry.update(Pkg.RegistrySpec(name="BCBIRegistry",uuid="26a550a3-39fe-4af4-af6d-e8814c2b6dd9")); 

try
    Pkg.Registry.add("General"); 
catch e
    @info("ignoring exception: ", e,)
end
try
    Pkg.Registry.update("General"); 
catch e
    @info("ignoring exception: ", e,)
end

println("The `BCBIRegistry` registry was installed successfully."); 