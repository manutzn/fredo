#' plot_fredo: Generate plots for FRED data
#'
#' This function takes a dataset extracted from the FRED API, creates plots for each unique FRED variable,
#' saves those plots as PDFs, and optionally generates LaTeX code for inclusion in documents.
#'
#' @param dataset A data frame containing FRED data with columns 'title', 'date', 'value', 'id', 'notes', and 'units_short'.
#' @param path A character string specifying the directory path where plots will be saved.
#' @param start The start date for filtering the data (format: 'YYYY-MM-DD').
#' @param end The end date for filtering the data (format: 'YYYY-MM-DD').
#' @param combine A logical value. If TRUE, plots all series on a single graph; if FALSE, creates individual plots.
#' @param show_recessions A logical value. If TRUE, includes recession bars in the plots; if FALSE, omits them.
#' @param generate_latex A logical value. If TRUE, generates LaTeX code for the plots; if FALSE, skips LaTeX generation.
#' @param plot_width The width of the plot in centimeters. Default is 14.14.
#' @param plot_height The height of the plot in centimeters. Default is 10.
#' @return This function does not return a value. It generates plots, saves them as PDFs, and optionally prints LaTeX code.
#' @import ggplot2 dplyr
#' @export
#'
#' @examples
#' # Example 1: Plot each series individually without recession bars (default plot size)
#' plot_fredo(
#'   dataset = fred_data,
#'   path = "output_directory/",
#'   start = '1950-01-01',
#'   end = '2024-12-31',
#'   combine = FALSE,
#'   show_recessions = FALSE,
#'   generate_latex = TRUE
#' )
#'
#' # Example 2: Combine all series into one plot with recession bars (custom plot size)
#' plot_fredo(
#'   dataset = fred_data,
#'   path = "output_directory/",
#'   start = '1950-01-01',
#'   end = '2024-12-31',
#'   combine = TRUE,
#'   show_recessions = TRUE,
#'   generate_latex = TRUE,
#'   plot_width = 20,  # Custom width
#'   plot_height = 15  # Custom height
#' )
#'
#' # Example 3: Plot each series individually with recession bars (custom plot size)
#' plot_fredo(
#'   dataset = fred_data,
#'   path = "output_directory/",
#'   start = '1950-01-01',
#'   end = '2024-12-31',
#'   combine = FALSE,
#'   show_recessions = TRUE,
#'   generate_latex = TRUE,
#'   plot_width = 16,  # Custom width
#'   plot_height = 12  # Custom height
#' )
#'
#' # Example 4: Combine all series into one plot without generating LaTeX code (default plot size)
#' plot_fredo(
#'   dataset = fred_data,
#'   path = "output_directory/",
#'   start = '1950-01-01',
#'   end = '2024-12-31',
#'   combine = TRUE,
#'   show_recessions = FALSE,
#'   generate_latex = FALSE
#' )
plot_fredo <- function(dataset, path, start = '1950-01-01', end = '2024-12-31',
                       combine = FALSE, show_recessions = TRUE, generate_latex = TRUE,
                       plot_width = 14.14, plot_height = 10) {
  # Load required libraries
  if (!requireNamespace("ggplot2", quietly = TRUE)) {
    stop("Package 'ggplot2' is required but is not installed.")
  }
  if (!requireNamespace("dplyr", quietly = TRUE)) {
    stop("Package 'dplyr' is required but is not installed.")
  }

  # Explicitly load the packages
  library(ggplot2)
  library(dplyr)

  # Define the path for the plots directory
  plots_dir <- file.path(path, "Plots")

  # Create the 'Plots' directory if it does not exist
  dir.create(plots_dir, recursive = TRUE, showWarnings = FALSE)

  # Define and filter recessions data
  recessions <- read.table(textConnection(
    "Peak, Trough
    1857-06-01, 1858-12-01
    1860-10-01, 1861-06-01
    1865-04-01, 1867-12-01
    1869-06-01, 1870-12-01
    1873-10-01, 1879-03-01
    1882-03-01, 1885-05-01
    1887-03-01, 1888-04-01
    1890-07-01, 1891-05-01
    1893-01-01, 1894-06-01
    1895-12-01, 1897-06-01
    1899-06-01, 1900-12-01
    1902-09-01, 1904-08-01
    1907-05-01, 1908-06-01
    1910-01-01, 1912-01-01
    1913-01-01, 1914-12-01
    1918-08-01, 1919-03-01
    1920-01-01, 1921-07-01
    1923-05-01, 1924-07-01
    1926-10-01, 1927-11-01
    1929-08-01, 1933-03-01
    1937-05-01, 1938-06-01
    1945-02-01, 1945-10-01
    1948-11-01, 1949-10-01
    1953-07-01, 1954-05-01
    1957-08-01, 1958-04-01
    1960-04-01, 1961-02-01
    1969-12-01, 1970-11-01
    1973-11-01, 1975-03-01
    1980-01-01, 1980-07-01
    1981-07-01, 1982-11-01
    1990-07-01, 1991-03-01
    2001-03-01, 2001-11-01
    2007-12-01, 2009-06-01
    2020-02-01, 2020-04-01"), sep = ',', colClasses = c('Date', 'Date'), header = TRUE) %>%
    filter(Peak >= as.Date(start) & Trough <= as.Date(end))

  # Function to add recession bars if show_recessions is TRUE
  add_recession_bars <- function(plot) {
    if (show_recessions) {
      plot <- plot + geom_rect(data = recessions, inherit.aes = FALSE,
                               aes(xmin = Peak, xmax = Trough, ymin = -Inf, ymax = Inf), fill = 'grey', alpha = 0.3)
    }
    return(plot)
  }

  # If combine is TRUE, plot all series in one graph
  if (combine) {
    # Create a combined plot
    p <- ggplot(dataset, aes(x = date, y = value, color = title)) +
      geom_line() +
      theme_minimal() +
      theme(
        legend.position = "bottom",
        legend.title = element_blank(),
        plot.caption = element_text(hjust = 0),
        plot.subtitle = element_text(face = "italic"),
        plot.title = element_text(size = 16, face = "bold")
      ) +
      labs(x = "Date", y = "Value", title = "Combined FRED Data Series")

    # Add recession bars if requested
    p <- add_recession_bars(p)

    # Save the combined plot
    ggsave(file.path(plots_dir, 'combined_plot.pdf'), p, width = plot_width, height = plot_height, units = "cm")

    # Generate and print LaTeX code for the combined plot if requested
    if (generate_latex) {
      latex_code <- sprintf(
        "\\begin{figure}[!h]\n\\centering\n\\caption{Combined FRED Data Series}\n\\includegraphics[scale=1]{Plots/combined_plot.pdf}\n\\label{combined_plot}\n\\end{figure}\n"
      )
      cat(latex_code, "\n\n")
    }

  } else {
    # Loop through each unique variable and generate individual plots
    unique_titles <- unique(dataset$title)

    lapply(unique_titles, function(var_title) {
      # Filter data for the current variable
      temp <- dataset %>% filter(title == var_title)

      # Skip if 'temp' is empty
      if (nrow(temp) == 0) return(NULL)

      # Adjust title formatting
      plot_title <- gsub('Rest of the World; ', 'Rest of the World\n', temp$title[1])

      # Create the plot
      p <- ggplot(temp, aes(x = date, y = value)) +
        geom_line(color = "#0645A4") +
        theme_minimal() +
        theme(
          legend.position = "bottom",
          legend.title = element_blank(),
          plot.caption = element_text(hjust = 0),
          plot.subtitle = element_text(face = "italic"),
          plot.title = element_text(size = 16, face = "bold")
        ) +
        labs(x = plot_title, y = temp$units_short[1])

      # Add recession bars if requested
      p <- add_recession_bars(p)

      # Save the plot as a PDF
      plot_path <- file.path(plots_dir, paste0(temp$id[1], '.pdf'))
      ggsave(plot_path, p, width = plot_width, height = plot_height, units = "cm")

      # Generate and print LaTeX code for the individual plot if requested
      if (generate_latex) {
        note_text <- gsub("\n", " ", temp$notes[1])
        latex_code <- sprintf(
          "\\begin{figure}[!h]\n\\centering\n\\caption{%s}\n\\includegraphics[scale=1]{Plots/%s}\n\\label{%s}\n\\parbox[1]{6.0in}{ \\vspace{1ex} \\footnotesize{%s\\hfill }}\n\\end{figure}\n",
          temp$title[1], temp$id[1], temp$id[1], note_text
        )
        cat(latex_code, "\n\n")
      }
    })
  }
}
