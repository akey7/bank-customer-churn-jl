module BankCustomerChurn

using CSV
using DataFrames
using FreqTables
using CategoricalArrays
using MLJ
using MLJBase
using Random
using DecisionTree

@load DecisionTreeClassifier pkg=DecisionTree

export read_churn_data, exited_vs_active_freqtable

"""
    read_churn_data(filename::String)

Read the churn data from the given filename and return the DataFrame

# Arguments
- `filename::String`: Path to the CSV file
"""
read_churn_data(filename::String) = CSV.read(filename, DataFrame)

"""
    exited_vs_active_freqtable(df::DataFrame)

Create frequency table with "exited" on the rows and "is_active_member" on
on the columns.

# Arguments
- `df::DataFrame`: DataFrame with churn data.
"""
function exited_vs_active_freqtable(df::DataFrame)
    df_copy = copy(df)
    df_copy.exited = categorical(df_copy.exited)
    df_copy.is_active_member = categorical(df_copy.is_active_member)
    freqtable(df_copy, :exited, :is_active_member)
end

function dt_classifier(df)
    row_indices = 1:nrow(df)
    train_indices, test_indices =
        partition(row_indices, 0.8, shuffle = true, rng = MersenneTwister(123))
    df_train = df[train_indices, :]
    df_test = df[test_indices, :]
    train_features, train_labels = unpack(df_train, ==(:exited))
    # dt_model = DecisionTreeClassifier()
    dt_model = MLJDecisionTreeInterface.DecisionTreeClassifier()

    max_depth_range = MLJBase.range(dt_model, :max_depth, lower = 2, upper = 20, scale = :linear, values = nothing)  # upper = 20
    min_samples_split_range = MLJBase.range(dt_model, :min_samples_split, lower = 1, upper = 10, scale = :linear, values = nothing)  # upper = 10

    tuning = TunedModel(
        model = dt_model,
        resampling = CV(nfolds = 5),
        ranges = [
            (:max_depth, max_depth_range),
            (:min_samples_split, min_samples_split_range),
        ],
        measure = cross_entropy,
        operation = :predict_mode,
        tuning = Grid(resolution = 10),
    )
    tuned_machine = machine(tuning, train_features, train_labels)
    MLJ.fit!(tuned_machine)
    test_features, test_labels = unpack(df_test, ==(:exited))
    pred_labels = predict(tuned_machine, test_features)

    combined_df = DataFrame(df_test, true_label = test_labels, pred_label = pred_labels)

end

end
