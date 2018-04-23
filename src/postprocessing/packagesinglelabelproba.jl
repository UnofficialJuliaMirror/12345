struct ImmutablePackageSingleLabelPredictProbaTransformer <:
        AbstractEstimator
    singlelabelname::T1 where T1 <: Symbol
end

function set_contrasts!(
        x::ImmutablePackageSingleLabelPredictProbaTransformer,
        contrasts::AbstractContrasts,
        )
    return nothing
end

function get_underlying(
        x::ImmutablePackageSingleLabelPredictProbaTransformer;
        saving::Bool = false,
        loading::Bool = false,
        )
    return nothing
end

function set_underlying!(
        x::ImmutablePackageSingleLabelPredictProbaTransformer,
        object;
        saving::Bool = false,
        loading::Bool = false,
        )
    return nothing
end

function get_history(
        x::ImmutablePackageSingleLabelPredictProbaTransformer;
        saving::Bool = false,
        loading::Bool = false,
        )
    return nothing
end

function set_history!(
        x::ImmutablePackageSingleLabelPredictProbaTransformer,
        h;
        saving::Bool = false,
        loading::Bool = false,
        )
    return nothing
end

function fit!(
        transformer::ImmutablePackageSingleLabelPredictProbaTransformer,
        varargs...;
        kwargs...
        )
    if length(varargs) == 1
        return varargs[1]
    else
        return varargs
    end
end

function predict(
        transformer::ImmutablePackageSingleLabelPredictProbaTransformer,
        varargs...;
        kwargs...
        )
    if length(varargs) == 1
        return varargs[1]
    else
        return varargs
    end
end

function predict_proba(
        transformer::ImmutablePackageSingleLabelPredictProbaTransformer,
        singlelabelprobabilities::Associative;
        kwargs...
        )
    result = Dict()
    result[transformer.singlelabelname] = singlelabelprobabilities
    return result
end
