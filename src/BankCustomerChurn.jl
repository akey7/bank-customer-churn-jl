module BankCustomerChurn

using CSV
using DataFrames

export read_churn_data

"""
    read_churn_data(filename::String)

Read the churn data from the given filename and return the DataFrame

# Arguments
- `filename::String`: Path to the CSV file
"""
read_churn_data(filename::String) = CSV.read(filename, DataFrame)

end
