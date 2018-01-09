import Knet
import StatsFuns
import ValueHistories

function _emptyfunction()
    return nothing
end

mutable struct MutableKnetjlNeuralNetworkEstimator <: AbstractPrimitiveObject
    name::T1 where T1 <: AbstractString
    isclassificationmodel::T2 where T2 <: Bool
    isregressionmodel::T3 where T3 <: Bool

    # hyperparameters (not learned from data):
    predict::T4 where T4 <: Function
    loss::T5 where T5 <: Function
    losshyperparameters::T6 where T6 <: Associative
    optimizationalgorithm::T7 where T7 <: Symbol
    optimizerhyperparameters::T8 where T8 <: Associative
    minibatchsize::T9 where T9 <: Integer
    maxepochs::T10 where T10 <: Integer
    printlosseverynepochs::T11 where T11 <: Integer

    # parameters (learned from data):
    modelweights::T12 where T12 <: AbstractArray
    modelweightoptimizers::T13 where T13

    # learning state
    history::T where T <: ValueHistories.MultivalueHistory

    function MutableKnetjlNeuralNetworkEstimator(
            ;
            name::AbstractString = "",
            predict::Function = _emptyfunction,
            loss::Function =_emptyfunction,
            losshyperparameters::Associative = Dict(),
            optimizationalgorithm::Symbol = :nothing,
            optimizerhyperparameters::Associative = Dict(),
            minibatchsize::Integer = 0,
            modelweights::AbstractArray = [],
            isclassificationmodel::Bool = false,
            isregressionmodel::Bool = false,
            maxepochs::Integer = 0,
            printlosseverynepochs::Integer = 0,
            )
        optimizersymbol2type = Dict()
        optimizersymbol2type[:Sgd] = Knet.Sgd
        optimizersymbol2type[:Momentum] = Knet.Momentum
        optimizersymbol2type[:Nesterov] = Knet.Nesterov
        optimizersymbol2type[:Rmsprop] = Knet.Rmsprop
        optimizersymbol2type[:Adagrad] = Knet.Adagrad
        optimizersymbol2type[:Adadelta] = Knet.Adadelta
        optimizersymbol2type[:Adam] = Knet.Adam
        modelweightoptimizers = Knet.optimizers(
            modelweights,
            optimizersymbol2type[optimizationalgorithm];
            optimizerhyperparameters...
            )
        lastepoch = 0
        lastiteration = 0
        history = ValueHistories.MVHistory()
        ValueHistories.push!(
            history,
            :epochatiteration,
            0,
            0,
            )
        result = new(
            name,
            isclassificationmodel,
            isregressionmodel,
            predict,
            loss,
            losshyperparameters,
            optimizationalgorithm,
            optimizerhyperparameters,
            minibatchsize,
            maxepochs,
            printlosseverynepochs,
            modelweights,
            modelweightoptimizers,
            history,
            )
        return result
    end
end

function setfeaturecontrasts!(
        x::MutableKnetjlNeuralNetworkEstimator,
        contrasts::AbstractContrasts,
        )
    return nothing
end

function getunderlying(
        x::MutableKnetjlNeuralNetworkEstimator;
        saving::Bool = false,
        loading::Bool = false,
        )
    result = (x.modelweights, x.modelweightoptimizers,)
    return result
end

function setunderlying!(
        x::MutableKnetjlNeuralNetworkEstimator,
        object;
        saving::Bool = false,
        loading::Bool = false,
        )
    x.modelweights = object[1]
    x.modelweightoptimizers = object[2]
    return nothing
end

function gethistory(
        x::MutableKnetjlNeuralNetworkEstimator;
        saving::Bool = false,
        loading::Bool = false,
        )
    result = x.history
    return result
end

function sethistory!(
        x::MutableKnetjlNeuralNetworkEstimator,
        h::ValueHistories.MultivalueHistory;
        saving::Bool = false,
        loading::Bool = false,
        )
    x.history = h
    return nothing
end

function fit!(
        estimator::MutableKnetjlNeuralNetworkEstimator,
        featuresarray::AbstractArray,
        labelsarray::AbstractArray,
        )
    featuresarray = Cfloat.(featuresarray)
    if estimator.isclassificationmodel && !estimator.isregressionmodel
        labelsarray = Int.(labelsarray)
    elseif !estimator.isclassificationmodel && estimator.isregressionmodel
        labelsarray = Cfloat.(labelsarray)
    else
        error("Could not figure out if model is classification or regression")
    end
    trainingdata = Knet.minibatch(
        featuresarray,
        labelsarray,
        estimator.minibatchsize,
        )
    lossgradient = Knet.grad(
        estimator.loss,
        2,
        )
    alliterationssofar, allepochssofar = ValueHistories.get(
        estimator.history,
        :epochatiteration,
        )
    lastiteration = alliterationssofar[end]
    lastepoch = allepochssofar[end]
    info(
        string(
            "Starting to train Knet.jl model. Max epochs: ",
            estimator.maxepochs,
            ".",
            )
        )
    lossbeforetrainingstarts = estimator.loss(
        estimator.predict,
        estimator.modelweights,
        featuresarray,
        labelsarray;
        estimator.losshyperparameters...
        )
    if (estimator.printlosseverynepochs) > 0
        info(
            string(
                "Epoch: ",
                lastepoch,
                ". Loss: ",
                lossbeforetrainingstarts,
                "."
                )
            )
    end
    while lastepoch < estimator.maxepochs
        for (x,y) in trainingdata
            grads = lossgradient(
                estimator.predict,
                estimator.modelweights,
                x,
                y;
                estimator.losshyperparameters...
                )
            Knet.update!(
                estimator.modelweights,
                grads,
                estimator.modelweightoptimizers,
                )
            lastiteration += 1
            currentiterationloss = estimator.loss(
                estimator.predict,
                estimator.modelweights,
                x,
                y;
                estimator.losshyperparameters...
                )
            ValueHistories.push!(
                estimator.history,
                :lossatiteration,
                lastiteration,
                currentiterationloss,
                )
        end # end for
        lastepoch += 1
        ValueHistories.push!(
            estimator.history,
            :epochatiteration,
            lastiteration,
            lastepoch,
            )
        currentepochloss = estimator.loss(
            estimator.predict,
            estimator.modelweights,
            featuresarray,
            labelsarray;
            estimator.losshyperparameters...
            )
        ValueHistories.push!(
            estimator.history,
            :lossatepoch,
            lastepoch,
            currentepochloss,
            )
        printlossthisepoch = (estimator.printlosseverynepochs > 0) &&
            ( (lastepoch == estimator.maxepochs) ||
                ( (lastepoch %
                    estimator.printlosseverynepochs) == 0 ) )
        if printlossthisepoch
            info(
                string(
                    "Epoch: ",
                    lastepoch,
                    ". Loss: ",
                    currentepochloss,
                    ".",
                    ),
                )
        end
    end # end while
    info(string("Finished training Knet.jl model."))
    return estimator
end

function predict(
        estimator::MutableKnetjlNeuralNetworkEstimator,
        featuresarray::AbstractArray,
        )
    if estimator.isclassificationmodel
        probabilitiesassoc = predict_proba(
            estimator,
            featuresarray,
            )
        predictionsvector = singlelabelprobabilitiestopredictions(
            probabilitiesassoc
            )
        return predictionsvector
    elseif estimator.isregressionmodel
        output = estimator.predict(
            estimator.modelweights,
            featuresarray;
            training = false,
            )
        outputtransposed = transpose(output)
        result = convert(Array, outputtransposed)
        return result
    else
        error("unable to predict")
    end
end

function predict_proba(
        estimator::MutableKnetjlNeuralNetworkEstimator,
        featuresarray::AbstractArray,
        )
    if estimator.isclassificationmodel
        output = estimator.predict(
            estimator.modelweights,
            featuresarray;
            training = false,
            )
        outputtransposed = transpose(output)
        numclasses = size(outputtransposed, 2)
        @assert(numclasses > 0)
        result = Dict()
        for i = 1:numclasses
            result[i] = outputtransposed[:, i]
        end
        return result
    elseif estimator.isregressionmodel
        error("predict_proba is not defined for regression models")
    else
        error("unable to predict")
    end
end

function _singlelabelknetclassifier_Knet(
        featurenames::AbstractVector,
        singlelabelname::Symbol,
        singlelabellevels::AbstractVector;
        name::AbstractString = "",
        predict::Function = _emptyfunction,
        loss::Function =_emptyfunction,
        losshyperparameters::Associative = Dict(),
        optimizationalgorithm::Symbol = :nothing,
        optimizerhyperparameters::Associative = Dict(),
        minibatchsize::Integer = 0,
        modelweights::AbstractArray = [],
        maxepochs::Integer = 0,
        printlosseverynepochs::Integer = 0,
        )
    labelnames = [singlelabelname]
    labellevels = Dict()
    labellevels[singlelabelname] = singlelabellevels
    dftransformer_index = 1
    dftransformer_transposefeatures = true
    dftransformer_transposelabels = true
    dftransformer = MutableDataFrame2ClassificationKnetTransformer(
        featurenames,
        labelnames,
        labellevels,
        dftransformer_index;
        transposefeatures = dftransformer_transposefeatures,
        transposelabels = dftransformer_transposelabels,
        )
    knetestimator = MutableKnetjlNeuralNetworkEstimator(
        ;
        name = name,
        predict = predict,
        loss = loss,
        losshyperparameters = losshyperparameters,
        optimizationalgorithm = optimizationalgorithm,
        optimizerhyperparameters = optimizerhyperparameters,
        minibatchsize = minibatchsize,
        modelweights = modelweights,
        isclassificationmodel = true,
        isregressionmodel = false,
        maxepochs = maxepochs,
        printlosseverynepochs = printlosseverynepochs,
        )
    predprobalabelfixer = ImmutablePredictProbaSingleLabelInt2StringTransformer(
        1,
        singlelabellevels
        )
    predictlabelfixer = ImmutablePredictionsSingleLabelInt2StringTransformer(
        1,
        singlelabellevels
        )
    probapackager = ImmutablePackageSingleLabelPredictProbaTransformer(
        singlelabelname,
        )
    predpackager = ImmutablePackageSingleLabelPredictionTransformer(
        singlelabelname,
        )
    finalpipeline = ImmutableSimpleLinearPipeline(
        [
            dftransformer,
            knetestimator,
            predprobalabelfixer,
            predictlabelfixer,
            probapackager,
            predpackager
            ];
        name = name,
        )
    return finalpipeline
end

function singlelabelknetclassifier(
        featurenames::AbstractVector,
        singlelabelname::Symbol,
        singlelabellevels::AbstractVector;
        package::Symbol = :none,
        name::AbstractString = "",
        predict::Function = _emptyfunction,
        loss::Function =_emptyfunction,
        losshyperparameters::Associative = Dict(),
        optimizationalgorithm::Symbol = :nothing,
        optimizerhyperparameters::Associative = Dict(),
        minibatchsize::Integer = 0,
        modelweights::AbstractArray = [],
        maxepochs::Integer = 0,
        printlosseverynepochs::Integer = 0,
        )
    if package == :Knetjl
        result = _singlelabelknetclassifier_Knet(
            featurenames,
            singlelabelname,
            singlelabellevels;
            name = name,
            predict = predict,
            loss = loss,
            losshyperparameters = losshyperparameters,
            optimizationalgorithm = optimizationalgorithm,
            optimizerhyperparameters = optimizerhyperparameters,
            minibatchsize = minibatchsize,
            modelweights = modelweights,
            maxepochs = maxepochs,
            printlosseverynepochs = printlosseverynepochs,
            )
        return result
    else
        error("$(package) is not a valid value for package")
    end
end

const knetclassifier = singlelabelknetclassifier

function _singlelabelknetregression_Knet(
        featurenames::AbstractVector,
        singlelabelname::Symbol;
        name::AbstractString = "",
        predict::Function = _emptyfunction,
        loss::Function =_emptyfunction,
        losshyperparameters::Associative = Dict(),
        optimizationalgorithm::Symbol = :nothing,
        optimizerhyperparameters::Associative = Dict(),
        minibatchsize::Integer = 0,
        modelweights::AbstractArray = [],
        maxepochs::Integer = 0,
        printlosseverynepochs::Integer = 0,
        )
    labelnames = [singlelabelname]
    dftransformer_index = 1
    dftransformer_transposefeatures = true
    dftransformer_transposelabels = true
    dftransformer = MutableDataFrame2RegressionKnetTransformer(
        featurenames,
        labelnames;
        transposefeatures = true,
        transposelabels = true,
        )
    knetestimator = MutableKnetjlNeuralNetworkEstimator(
        ;
        name = name,
        predict = predict,
        loss = loss,
        losshyperparameters = losshyperparameters,
        optimizationalgorithm = optimizationalgorithm,
        optimizerhyperparameters = optimizerhyperparameters,
        minibatchsize = minibatchsize,
        modelweights = modelweights,
        isclassificationmodel = false,
        isregressionmodel = true,
        maxepochs = maxepochs,
        printlosseverynepochs = printlosseverynepochs,
        )
    predpackager = ImmutablePackageMultiLabelPredictionTransformer(
        [singlelabelname,],
        )
    finalpipeline = ImmutableSimpleLinearPipeline(
        [
            dftransformer,
            knetestimator,
            predpackager,
            ];
        name = name,
        )
    return finalpipeline
end

function singlelabelknetregression(
        featurenames::AbstractVector,
        singlelabelname::Symbol;
        package::Symbol = :none,
        name::AbstractString = "",
        predict::Function = _emptyfunction,
        loss::Function =_emptyfunction,
        losshyperparameters::Associative = Dict(),
        optimizationalgorithm::Symbol = :nothing,
        optimizerhyperparameters::Associative = Dict(),
        minibatchsize::Integer = 0,
        modelweights::AbstractArray = [],
        maxepochs::Integer = 0,
        printlosseverynepochs::Integer = 0,
        )
    if package == :Knetjl
        result = _singlelabelknetregression_Knet(
            featurenames,
            singlelabelname;
            name = name,
            predict = predict,
            loss = loss,
            losshyperparameters = losshyperparameters,
            optimizationalgorithm = optimizationalgorithm,
            optimizerhyperparameters = optimizerhyperparameters,
            minibatchsize = minibatchsize,
            modelweights = modelweights,
            maxepochs = maxepochs,
            printlosseverynepochs = printlosseverynepochs,
            )
        return result
    else
        error("$(package) is not a valid value for package")
    end
end

const knetregression = singlelabelknetregression
