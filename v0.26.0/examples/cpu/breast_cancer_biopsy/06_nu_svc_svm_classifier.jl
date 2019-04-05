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
    "breast_cancer_biopsy_example",
    )



### End project-specific settings

### Begin nu-SVC code

import PredictMDFull

import Pkg
try Pkg.add("StatsBase") catch end
import StatsBase

import Statistics

Kernel = LIBSVM.Kernel

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

smoted_training_features_df_filename = joinpath(
    PROJECT_OUTPUT_DIRECTORY,
    "smoted_training_features_df.csv",
    )
smoted_training_labels_df_filename = joinpath(
    PROJECT_OUTPUT_DIRECTORY,
    "smoted_training_labels_df.csv",
    )
smoted_training_features_df = CSV.read(
    smoted_training_features_df_filename,
    DataFrames.DataFrame;
    rows_for_type_detect = 100,
    )
smoted_training_labels_df = CSV.read(
    smoted_training_labels_df_filename,
    DataFrames.DataFrame;
    rows_for_type_detect = 100,
    )

categorical_feature_names_filename = joinpath(
    PROJECT_OUTPUT_DIRECTORY,
    "categorical_feature_names.jld2",
    )
continuous_feature_names_filename = joinpath(
    PROJECT_OUTPUT_DIRECTORY,
    "continuous_feature_names.jld2",
    )
categorical_feature_names = FileIO.load(
    categorical_feature_names_filename,
    "categorical_feature_names",
    )
continuous_feature_names = FileIO.load(
    continuous_feature_names_filename,
    "continuous_feature_names",
    )
feature_names = vcat(categorical_feature_names, continuous_feature_names)

single_label_name = :Class
negative_class = "benign"
positive_class = "malignant"
single_label_levels = [negative_class, positive_class]

categorical_label_names = Symbol[single_label_name]
continuous_label_names = Symbol[]
label_names = vcat(categorical_label_names, continuous_label_names)

feature_contrasts = PredictMD.generate_feature_contrasts(
    smoted_training_features_df,
    feature_names,
    )

nu_svc_svm_classifier =
    PredictMD.single_labelmulticlassdataframesvmclassifier(
        feature_names,
        single_label_name,
        single_label_levels;
        package = :LIBSVM,
        svmtype = LIBSVM.NuSVC,
        name = "SVM (nu-SVC)",
        verbose = false,
        feature_contrasts = feature_contrasts,
        )

PredictMD.fit!(
    nu_svc_svm_classifier,
    smoted_training_features_df,
    smoted_training_labels_df,
    )

nu_svc_svm_classifier_hist_training =
    PredictMD.plotsinglelabelbinaryclassifierhistogram(
        nu_svc_svm_classifier,
        smoted_training_features_df,
        smoted_training_labels_df,
        single_label_name,
        single_label_levels,
        );



display(nu_svc_svm_classifier_hist_training)

nu_svc_svm_classifier_hist_testing =
    PredictMD.plotsinglelabelbinaryclassifierhistogram(
        nu_svc_svm_classifier,
        testing_features_df,
        testing_labels_df,
        single_label_name,
        single_label_levels,
        );



display(nu_svc_svm_classifier_hist_testing)

PredictMD.singlelabelbinaryclassificationmetrics(
    nu_svc_svm_classifier,
    smoted_training_features_df,
    smoted_training_labels_df,
    single_label_name,
    positive_class;
    sensitivity = 0.95,
    )

PredictMD.singlelabelbinaryclassificationmetrics(
    nu_svc_svm_classifier,
    testing_features_df,
    testing_labels_df,
    single_label_name,
    positive_class;
    sensitivity = 0.95,
    )

nu_svc_svm_classifier_filename = joinpath(
    PROJECT_OUTPUT_DIRECTORY,
    "nu_svc_svm_classifier.jld2",
    )

PredictMD.save_model(
    nu_svc_svm_classifier_filename,
    nu_svc_svm_classifier,
    )

### End nu-SVC code



##### End of file

# This file was generated using Literate.jl, https://github.com/fredrikekre/Literate.jl
