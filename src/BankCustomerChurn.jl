module BankCustomerChurn

using CSV
using DataFrames
using MLJ
using DecisionTree

export read_churn_data, evaluate_decision_tree_classifier

"""
    read_churn_data(filename::String)

Read the churn data from the given filename and return the DataFrame

# Arguments
- `filename::String`: Path to the CSV file
"""
function read_churn_data(filename::String)
    df = CSV.read(filename, DataFrame)
    coerce(
        df,
        :credit_score => Continuous,
        :estimated_salary => Continuous,
        :age => Continuous,
        :tenure => Continuous,
        :balance => Continuous,
        :female => Multiclass,
        :num_of_products => Continuous,
        :has_cr_card => Multiclass,
        :is_active_member => Multiclass,
        :exited => Multiclass,
    )
end

"""
    evaluate_decision_tree_classifier(df::DataFrame)

# Arguments
- `df::DataFrame`: DataFrame with scitypes coerced onto it (this is done by `read_churn_data()`)
"""
function evaluate_decision_tree_classifier(df::DataFrame)
    Tree = @load DecisionTreeClassifier pkg = DecisionTree verbosity = 0
    y, X = unpack(df, ==(:exited), rng = 123)
    tree = Tree()
    mach = machine(tree, X, y, scitype_check_level = 0)
    evaluate!(
        mach,
        resampling = Holdout(fraction_train = 0.7),
        measures = [log_loss, accuracy],
        verbosity = 1,
    )
end

end
