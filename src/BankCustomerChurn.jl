module BankCustomerChurn

using CSV
using DataFrames
using FreqTables
using CategoricalArrays
using MLJ
using MLJBase
using Random
using DecisionTree

export read_churn_data, exited_vs_active_freqtable

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
        :exited => Multiclass
    )
end

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

end
