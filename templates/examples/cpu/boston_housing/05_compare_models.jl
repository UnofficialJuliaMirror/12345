##### Beginning of file

error(string("This file is not meant to be run. Use the `PredictMD.generate_examples()` function to generate examples that you can run."))

%PREDICTMD_GENERATED_BY%

# BEGIN TEST STATEMENTS
import Base.Test
Base.Test.@test( 1 == 1 )
# END TEST STATEMENTS

import PredictMD

### Begin project-specific settings

PredictMD.require_julia_version("v0.6")

PredictMD.require_predictmd_version("%PREDICTMD_CURRENT_VERSION%")

## PredictMD.require_predictmd_version("%PREDICTMD_CURRENT_VERSION%", "%PREDICTMD_NEXT_MINOR_VERSION%")

PROJECT_OUTPUT_DIRECTORY = PredictMD.project_directory(
    homedir(),
    "Desktop",
    "boston_housing_example",
    )

### End project-specific settings

### Begin model comparison code

import CSV
import Compat
import DataFrames
import FileIO
import JLD2
import Knet

srand(999)

trainingandvalidation_features_df_filename = joinpath(
    PROJECT_OUTPUT_DIRECTORY,
    "trainingandvalidation_features_df.csv",
    )
trainingandvalidation_labels_df_filename = joinpath(
    PROJECT_OUTPUT_DIRECTORY,
    "trainingandvalidation_labels_df.csv",
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
validation_features_df_filename = joinpath(
    PROJECT_OUTPUT_DIRECTORY,
    "validation_features_df.csv",
    )
validation_labels_df_filename = joinpath(
    PROJECT_OUTPUT_DIRECTORY,
    "validation_labels_df.csv",
    )
trainingandvalidation_features_df = CSV.read(
    trainingandvalidation_features_df_filename,
    DataFrames.DataFrame;
    rows_for_type_detect = 100,
    )
trainingandvalidation_labels_df = CSV.read(
    trainingandvalidation_labels_df_filename,
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
validation_features_df = CSV.read(
    validation_features_df_filename,
    DataFrames.DataFrame;
    rows_for_type_detect = 100,
    )
validation_labels_df = CSV.read(
    validation_labels_df_filename,
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

Compat.@info(PredictMD.singlelabelregressionmetrics(
    all_models,
    training_features_df,
    training_labels_df,
    single_label_name,
    ))

Compat.@info(PredictMD.singlelabelregressionmetrics(
    all_models,
    testing_features_df,
    testing_labels_df,
    single_label_name,
    ))

### End model comparison code

##### End of file