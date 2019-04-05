##### Beginning of file

# This file was generated by PredictMD version 0.26.0
# For help, please visit https://predictmd.net

import PredictMD

### Begin project-specific settings

PredictMD.require_julia_version("v1.1.0")

PredictMD.require_predictmd_version("0.26.0")

# PredictMD.require_predictmd_version("0.26.0", "0.27.0-")

PROJECT_OUTPUT_DIRECTORY = PredictMD.project_directory(
    homedir(),
    "Desktop",
    "boston_housing_example",
    )



### End project-specific settings

### Begin model comparison code

import PredictMDFull

import LinearAlgebra
import Random
import Statistics
try Pkg.add("GLM") catch end
try Pkg.add("Distributions") catch end
try Pkg.add("StatsModels") catch end
import GLM
import Distributions
import StatsModels

import Pkg
try Pkg.add("StatsBase") catch end
import StatsBase

Random.seed!(999)

trainingandtuning_features_df_filename = joinpath(
    PROJECT_OUTPUT_DIRECTORY,
    "trainingandtuning_features_df.csv",
    )
trainingandtuning_labels_df_filename = joinpath(
    PROJECT_OUTPUT_DIRECTORY,
    "trainingandtuning_labels_df.csv",
    )
testing_features_df_filename = joinpath(
    PROJECT_OUTPUT_DIRECTORY,
    "testing_features_df.csv",
    )
testing_labels_df_filename = joinpath(
    PROJECT_OUTPUT_DIRECTORY,
    "testing_labels_df.csv",
    )
training_features_df_filename = joinpath(
    PROJECT_OUTPUT_DIRECTORY,
    "training_features_df.csv",
    )
training_labels_df_filename = joinpath(
    PROJECT_OUTPUT_DIRECTORY,
    "training_labels_df.csv",
    )
tuning_features_df_filename = joinpath(
    PROJECT_OUTPUT_DIRECTORY,
    "tuning_features_df.csv",
    )
tuning_labels_df_filename = joinpath(
    PROJECT_OUTPUT_DIRECTORY,
    "tuning_labels_df.csv",
    )
trainingandtuning_features_df = CSV.read(
    trainingandtuning_features_df_filename,
    DataFrames.DataFrame;
    rows_for_type_detect = 100,
    )
trainingandtuning_labels_df = CSV.read(
    trainingandtuning_labels_df_filename,
    DataFrames.DataFrame;
    rows_for_type_detect = 100,
    )
testing_features_df = CSV.read(
    testing_features_df_filename,
    DataFrames.DataFrame;
    rows_for_type_detect = 100,
    )
testing_labels_df = CSV.read(
    testing_labels_df_filename,
    DataFrames.DataFrame;
    rows_for_type_detect = 100,
    )
training_features_df = CSV.read(
    training_features_df_filename,
    DataFrames.DataFrame;
    rows_for_type_detect = 100,
    )
training_labels_df = CSV.read(
    training_labels_df_filename,
    DataFrames.DataFrame;
    rows_for_type_detect = 100,
    )
tuning_features_df = CSV.read(
    tuning_features_df_filename,
    DataFrames.DataFrame;
    rows_for_type_detect = 100,
    )
tuning_labels_df = CSV.read(
    tuning_labels_df_filename,
    DataFrames.DataFrame;
    rows_for_type_detect = 100,
    )

linear_regression_filename = joinpath(
    PROJECT_OUTPUT_DIRECTORY,
    "linear_regression.jld2",
    )
random_forest_regression_filename = joinpath(
    PROJECT_OUTPUT_DIRECTORY,
    "random_forest_regression.jld2",
    )
knet_mlp_regression_filename = joinpath(
    PROJECT_OUTPUT_DIRECTORY,
    "knet_mlp_regression.jld2",
    )

linear_regression =
    PredictMD.load_model(linear_regression_filename)
random_forest_regression =
    PredictMD.load_model(random_forest_regression_filename)
knet_mlp_regression =
    PredictMD.load_model(knet_mlp_regression_filename)
PredictMD.parse_functions!(knet_mlp_regression)

all_models = PredictMD.Fittable[
    linear_regression,
    random_forest_regression,
    knet_mlp_regression,
    ]

single_label_name = :MedV

continuous_label_names = Symbol[single_label_name]
categorical_label_names = Symbol[]
label_names = vcat(categorical_label_names, continuous_label_names)

println("Single label regression metrics, training set: ")
show(
    PredictMD.singlelabelregressionmetrics(
        all_models,
        training_features_df,
        training_labels_df,
        single_label_name,
        ),
    allcols=true,
    )

println("Single label regression metrics, testing set: ")
show(
    PredictMD.singlelabelregressionmetrics(
        all_models,
        testing_features_df,
        testing_labels_df,
        single_label_name,
        ),
    allcols=true,
    )

### End model comparison code



##### End of file

# This file was generated using Literate.jl, https://github.com/fredrikekre/Literate.jl

