% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/interface.R
\name{empiric_tox_rate}
\alias{empiric_tox_rate}
\title{Observed toxicity rate at each dose.}
\usage{
empiric_tox_rate(x, ...)
}
\arguments{
\item{x}{Object of class \code{\link{selector}}}

\item{...}{arguments passed to other methods}
}
\value{
a numerical vector
}
\description{
Get the empirical or observed toxicity rate seen at each dose under
investigation. This is simply the number of toxicities divded by the number
of patients evaluated.
}
\examples{
# CRM example
skeleton <- c(0.05, 0.1, 0.25, 0.4, 0.6)
target <- 0.25
outcomes <- '1NNN 2NTN'
fit <- get_dfcrm(skeleton = skeleton, target = target) \%>\% fit(outcomes)
fit \%>\% empiric_tox_rate()
}
