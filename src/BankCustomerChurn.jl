module BankCustomerChurn

using CSV
using DataFrames

read_churn_data(filename) = CSV.read(filename, DataFrame)

end
