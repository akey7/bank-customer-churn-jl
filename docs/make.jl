using Documenter
using BankCustomerChurn

push!(LOAD_PATH, "../src/")

makedocs(sitename="BankCustomerChurn Documentation", modules=[BankCustomerChurn])
