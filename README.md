# fredo

**Fetch Data from the Federal Reserve Economic Data (FRED) API**

![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)
![R](https://img.shields.io/badge/R-%E2%89%A5%203.5.0-blue)
![CRAN](https://img.shields.io/badge/CRAN-Unreleased-red)

## Table of Contents

- [Description](#description)
- [Features](#features)
- [Installation](#installation)
- [Prerequisites](#prerequisites)
- [Usage](#usage)
  - [Setting Up Your FRED API Key](#setting-up-your-fred-api-key)
  - [Fetching Data](#fetching-data)
- [Examples](#examples)
- [License](#license)
- [Contributing](#contributing)
- [Acknowledgments](#acknowledgments)

## Description

`fredo` is an R package that provides functions to fetch economic data series from the [Federal Reserve Economic Data (FRED) API](https://fred.stlouisfed.org/). It allows users to easily retrieve and analyze economic indicators and data series for research, analysis, and visualization.

## Features

- Fetch time-series data for multiple economic indicators.
- Retrieve metadata and series information.
- Efficiently manage API requests and data handling.
- Support for customizable date ranges and multiple series IDs.

## Installation

As `fredapi` is not yet available on CRAN, you can install it directly from GitHub:

```r
# Install devtools if not already installed
install.packages("devtools")

# Install fredapi from GitHub
devtools::install_github("manutzn/fredo")
