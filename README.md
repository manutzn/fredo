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
```

## Prerequisites

The package depends on the following R packages:

- `httr` (≥ 1.4.0)
- `jsonlite` (≥ 1.6)
- `dplyr` (≥ 0.8.0)

You can install these packages using:

```r
install.packages(c("httr", "jsonlite", "dplyr"))
```

## Usage

### Setting Up Your FRED API Key

To use the FRED API, you need to obtain an API key:

1. **Register for an API Key:**

   - Visit the [FRED API Key Registration](https://fred.stlouisfed.org/docs/api/api_key.html) page.
   - Follow the instructions to register and obtain your unique API key.

2. **Store Your API Key Securely:**

   - **Option 1:** Assign it directly in your R script (not recommended for shared code).

     ```r
     api_key <- "your_api_key_here"
     ```

   - **Option 2:** Set it as an environment variable in your `.Renviron` file.

     Add the following line to your `.Renviron` file:

     ```
     FRED_API_KEY=your_api_key_here
     ```

     Then access it in R using:

     ```r
     api_key <- Sys.getenv("FRED_API_KEY")
     ```

### Fetching Data

Use the `fredo()` function to retrieve data from the FRED API.

**Function Signature:**

```r
fredo(api_key, series_ids, start_date, end_date)
```

**Parameters:**

- `api_key`: Your FRED API key as a string.
- `series_ids`: A character vector of FRED series IDs to retrieve.
- `start_date`: Start date for data retrieval in `'YYYY-MM-DD'` format.
- `end_date`: End date for data retrieval in `'YYYY-MM-DD'` format.

**Returns:**

- A data frame containing the combined data for all specified series.

## Examples

```r
# Load the fredapi package
library(fredapi)

# Set your FRED API key
api_key <- Sys.getenv("FRED_API_KEY")  # Recommended method

# Define the series IDs and date range
series_ids <- c("GNPCA", "UNRATE")
start_date <- "1950-01-01"
end_date <- "2024-12-31"

# Fetch the data
data <- fredo(api_key, series_ids, start_date, end_date)

# View the first few rows of the data
head(data)
```

**Sample Output:**

```
        date   value     id                          title
1 1950-01-01 2198.50  GNPCA  Real Gross National Product
2 1951-01-01 2373.70  GNPCA  Real Gross National Product
3 1952-01-01 2474.70  GNPCA  Real Gross National Product
4 1953-01-01 2607.70  GNPCA  Real Gross National Product
5 1954-01-01 2635.10  GNPCA  Real Gross National Product
6 1955-01-01 2808.50  GNPCA  Real Gross National Product
```

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

```
MIT License

Copyright (c) 2024 Manu Garcia

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
```


Contributing
------------

Contributions are welcome! 

Acknowledgments
---------------

-   FRED® API
-   [R Packages Book by Hadley Wickham](https://r-pkgs.org/)
-   httr Package
-   jsonlite Package
-   dplyr Package

* * * * *

**Note:** Remember to replace placeholder text like `"your_api_key_here"` with your actual API key or guide users on how to set their own API key securely.
