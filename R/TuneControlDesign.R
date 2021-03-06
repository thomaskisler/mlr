#' @param design [\code{data.frame}]\cr
#'   \code{data.frame} containing the different parameter settings to be evaluated.
#'   The columns have to be named according to the \code{ParamSet} which will be used in \code{tune()}.
#'   Proper designs can be created with \code{\link[ParamHelpers]{generateDesign}} for instance.
#' @export
#' @rdname TuneControl
makeTuneControlDesign = function(same.resampling.instance = TRUE, impute.val = NULL, design = NULL,
  tune.threshold = FALSE, tune.threshold.args = list(), log.fun = NULL) {
  assertDataFrame(design, min.rows = 1)
  makeTuneControl(same.resampling.instance = same.resampling.instance, impute.val = impute.val,
    start = NULL, design = design,
    tune.threshold = tune.threshold, tune.threshold.args = tune.threshold.args,
    log.fun = log.fun, cl = "TuneControlDesign")
}
