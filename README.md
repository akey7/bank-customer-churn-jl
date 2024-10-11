# bank-customer-churn-jl
Machine learning models for bank customer churn data. The dataset (stored separately from this repo) is from a Maven Analytics guided project on a bank customer churn dataset. This repo is meant as a basic test of Julia machine learning functionality.

## Setup

### Install the Julia environment

Julia dependencies for this repo need to be installed. From the root of this repo, type `julia`. At the prompt, type `]`. Then type the following:

```
(@v1.10) pkg> activate .
(bank-customer-churn-jl) pkg> instantiate
[backspace]
julia> exit()
```

After the latter command finishes, type backspace, then:

```
julia> exit()
```

### Jupyter Notebooks for Quarto and Julia Jupyter Support

First, create a virtual environment for **Python** and install Jupyter Lab in it. This is required for Quarto builds of Julia. Run these commands from the root of the repo:

```
conda create --prefix env python=3.11
conda activate ./env
conda install jupyterlab
```

[See this page for additional guidance.](https://quarto.org/docs/projects/virtual-environments.html)

### The Julia Kernel for Jupyter

To run this part of the setup, the Python environment above should be activated so that Jupyter can install an additional kernel.

[First install IJulia according to these instructions.](https://julialang.github.io/IJulia.jl/stable/manual/installation/). In brief, the relevant commands are:

```
julia
using Pkg
Pkg.add("IJulia")
using IJulia
installkernel("Julia", "--project=@.")
```

Note: Sometimes this does not need to be done, but those are the commands in case you need them!

### Quarto installation

[This only needs to be done once per machine for each upgrade of Quarto.](https://quarto.org/docs/get-started/)

### FINALLY! Check the Quarto installation

```
quarto check jupyter
```

If everything comes back good, you are ready to continue!

### Build documentation

To build the documentation which nicely presents docstrings of the Julia code that lives outside the Quarto file, you need to build the docs project. To start, run the following commands:

```
cd docs/
julia --project=.
]
(docs) pkg> instantiate
[backspace]
julia> exit()
```

Then, from a command prompt, type

```
julia --project=. make.jl
```

If everything went well, there will be a `docs/build/index.html` that you can open to read the documentation!
