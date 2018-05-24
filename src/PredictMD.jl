__precompile__(true)

"""
"""
module PredictMD

##############################################################################
Top level ####################################################################
##############################################################################

# base/
# (base must go first)
include("base/interface.jl")
include("base/types.jl")
include("base/version.jl")

# deprecations/
# (deprecations must go second)
include("deprecations/deprecated.jl")

# calibration/

# classimbalance/
include("classimbalance/smote.jl")

# cluster/

# datasets/
include("datasets/csv.jl")
include("datasets/gzip.jl")
include("datasets/rdatasets.jl")

# decomposition/

# ensemble/

# integrations/
include("integrations/ide/atom.jl")
include("integrations/literate_programming/literate.jl")
include("integrations/literate_programming/weave.jl")

# io/
include("io/saveload.jl")

# linearmodel/
include("linearmodel/glm.jl")
include("linearmodel/ordinary_least_squares_regression.jl")

# metrics/
include("metrics/auprc.jl")
include("metrics/aurocc.jl")
include("metrics/averageprecisionscore.jl")
include("metrics/brier_score.jl")
include("metrics/coefficientofdetermination.jl")
include("metrics/cohenkappa.jl")
include("metrics/getbinarythresholds.jl")
include("metrics/mean_square_error.jl")
include("metrics/prcurve.jl")
include("metrics/risk_score_cutoff_values.jl")
include("metrics/roccurve.jl")
include("metrics/rocnumsmetrics.jl")
include("metrics/singlelabelbinaryclassificationmetrics.jl")
include("metrics/singlelabelregressionmetrics.jl")

# modelselection/
include("modelselection/split_data.jl")

# multiclass/

# multioutput/

# neuralnetwork/
include("neuralnetwork/flux.jl")
include("neuralnetwork/knet.jl")

# pipeline/
include("pipeline/simplelinearpipeline.jl")

# plotting/
include("plotting/plotlearningcurve.jl")
include("plotting/plotprcurve.jl")
include("plotting/plotroccurve.jl")
include("plotting/plotsinglelabelregressiontruevspredicted.jl")
include("plotting/plotsinglelabelbinaryclassifierhistograms.jl")
include("plotting/probability_calibration_plots.jl")

# postprocessing/
include("postprocessing/packagemultilabelpred.jl")
include("postprocessing/packagesinglelabelpred.jl")
include("postprocessing/packagesinglelabelproba.jl")
include("postprocessing/predictoutput.jl")
include("postprocessing/predictprobaoutput.jl")

# preprocessing/
include("preprocessing/dataframecontrasts.jl")
include("preprocessing/dataframetodecisiontree.jl")
include("preprocessing/dataframetoglm.jl")
include("preprocessing/dataframetoknet.jl")
include("preprocessing/dataframetosvm.jl")

# svm/
include("svm/libsvm.jl")

# tree/
include("tree/decisiontree.jl")

# utils/
include("utils/file_exists.jl")
include("utils/fix_dict_type.jl")
include("utils/fix_vector_type.jl")
include("utils/formulas.jl")
include("utils/labelstringintmaps.jl")
include("utils/missings.jl")
include("utils/nothings.jl")
include("utils/openbrowserwindow.jl")
include("utils/openplotsduringtestsenv.jl")
include("utils/predictionsassoctodataframe.jl")
include("utils/probabilitiestopredictions.jl")
include("utils/runtestsenv.jl")
include("utils/shufflerows.jl")
include("utils/simplemovingaverage.jl")
include("utils/tikzpictures.jl")
include("utils/trapz.jl")
include("utils/traviscienv.jl")

##############################################################################
Submodules ###################################################################
##############################################################################

# submodules/clean/
include("submodules/clean/clean.jl")

# submodules/gpu/
include("submodules/gpu/gpu.jl")

end # end module PredictMD
