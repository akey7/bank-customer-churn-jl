module BankCustomerChurn

using CSV
using DataFrames

export read_churn_data

read_churn_data(filename) = CSV.read(filename, DataFrame)

end
