
#' @title Parse a string of phase I dose-finding outcomes to vector notation.
#'
#' @description Parse a string of phase I dose-finding outcomes to a binary
#' vector notation necessary for model invocation.
#'
#' The outcome string describes the doses given, outcomes observed and groups
#' patients into cohorts. The format of the string is described in Brock (2019),
#' and that itself is the phase I analogue of the similar idea described in
#' Brock et al. (2017). See Examples.
#'
#' The letters T and N are used to represents patients that experienced
#' (T)oxicity and (N)o toxicity. These letters are concatenated after numerical
#' dose-levels to convey the outcomes of cohorts of patients.
#' For instance, \code{2NNT} represents a cohort of three patients that were
#' treated at dose-level 2, one of whom experienced toxicity, and two that did
#' not. The results of cohorts are separated by spaces. Thus, \code{2NNT 1NN}
#' extends our previous example, where the next cohort of two were treated at
#' dose-level 1 and neither experienced toxicity. See examples.
#'
#' @param outcomes character string, conveying doses given and outcomes
#' observed.
#' @param as_list TRUE (the default) to return a \code{list};
#' FALSE to return a \code{data.frame}
#'
#' @return If \code{as_list == TRUE}, a list with elements \code{tox},
#' \code{doses} and \code{num_patients}. If \code{as_list == FALSE}, a
#' data.frame with columns \code{tox} and \code{doses}.
#'
#' @export
#'
#' @examples
#' x = parse_phase1_outcomes('1NNN 2NTN 3TTT')
#' # Three cohorts of three patients. The first cohort was treated at dose 1 and
#' # none had toxicity. The second cohort was treated at dose 2 and one of the
#' # three had toxicity. Finally, cohort three was treated at dose 3 and all
#' # patients had toxicity.
#' x$num_patients  # 9
#' x$doses         # c(1, 1, 1, 2, 2, 2, 3, 3, 3)
#' x$tox           # c(0, 0, 0, 0, 1, 0, 1, 1, 1)
#' sum(x$tox)      # 4
#'
#' # The same information can be parsed to a data-frame:
#' y = parse_phase1_outcomes('1NNN 2NTN 3TTT', as_list = FALSE)
#' y
#' @references
#' Brock, K. (2019). trialr: Bayesian Clinical Trial Designs in R and Stan.
#' arXiv:1907.00161 [stat.CO]
#'
#' Brock, K., Billingham, L., Copland, M., Siddique, S., Sirovica, M., & Yap, C.
#' (2017). Implementing the EffTox dose-finding design in the Matchpoint trial.
#' BMC Medical Research Methodology, 17(1), 112.
#' https://doi.org/10.1186/s12874-017-0381-x
#'
#' @importFrom magrittr "%>%"
#' @importFrom stringr str_split
#' @importFrom tibble tibble
#'
parse_phase1_outcomes <- function(outcomes, as_list = TRUE) {

  cohorts <- phase1_outcomes_to_cohorts(outcomes)
  dose <- integer(length = 0)
  tox <- integer(length = 0)
  cohort_ids <- integer(length = 0)
  cohort_id <- 1
  for(cohort in cohorts) {
    c_dl <- cohort$dose
    c_outcomes <- cohort$outcomes

    these_outcomes <- str_split(c_outcomes, '')[[1]]
    these_tox = as.integer((these_outcomes == 'T'))
    these_dose <- rep(c_dl, length(these_tox))

    dose <- c(dose, these_dose)
    tox = c(tox, these_tox)
    cohort_ids <- c(cohort_ids, rep(cohort_id, length(these_dose)))
    cohort_id <- cohort_id + 1
  }

  if(as_list) {
    return(list(
      cohort = cohort_ids, patient = seq_along(dose),
      dose = dose, tox = tox, num_patients = length(dose)
    ))
  } else {
    return(tibble(
      cohort = as.integer(cohort_ids),
      patient = seq_along(dose),
      dose = dose,
      tox = tox)
    )
  }
}
