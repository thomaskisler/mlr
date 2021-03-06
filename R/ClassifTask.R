#' @export
#' @rdname Task
makeClassifTask = function(id, data, target, weights = NULL, blocking = NULL,
  positive = NA_character_, fixup.data = "warn", check.data = TRUE) {
  assertChoice(fixup.data, choices = c("no", "quiet", "warn"))
  assertFlag(check.data)

  task = addClasses(makeSupervisedTask("classif", data, target, weights, blocking), "ClassifTask")
  if (fixup.data != "no")
    fixupData(task, target, fixup.data)
  if (check.data)
    checkTaskCreation(task, target)
  id = checkOrGuessId(id, data)
  task$task.desc = makeTaskDesc.ClassifTask(task, id, target, positive)
  return(task)
}

checkTaskCreation.ClassifTask = function(task, target, ...) {
  NextMethod("checkTaskCreation")
  assertString(target)
  assertFactor(task$env$data[[target]], any.missing = FALSE, empty.levels.ok = FALSE, .var.name = target)
}

fixupData.ClassifTask = function(task, target, choice, ...) {
  NextMethod("fixupData")
  x = task$env$data[[target]]
  if (is.character(x) || is.logical(x) || is.integer(x))
    task$env$data[[target]] = as.factor(x)
}

makeTaskDesc.ClassifTask = function(task, id, target, positive) {
  levs = levels(task$env$data[[target]])
  m = length(levs)
  if (is.na(positive)) {
    if (m <= 2L)
      positive = levs[1L]
  } else {
    if (m > 2L)
      stop("Cannot set a positive class for a multiclass problem!")
    assertChoice(positive, choices = levs)
  }
  td = makeTaskDescInternal(task, "classif", id, target)
  td$class.levels = levs
  td$positive = positive
  td$negative = NA_character_
  if (length(td$class.levels) == 1L)
    td$negative = paste0("not_", positive)
  else if(length(td$class.levels) == 2L)
    td$negative = setdiff(td$class.levels, positive)
  return(addClasses(td, "TaskDescClassif"))
}

#' @export
print.ClassifTask = function(x, ...) {
  # remove 1st newline
  di = printToChar(table(getTaskTargets(x)), collapse = NULL)[-1L]
  m = length(x$task.desc$class.levels)
  print.SupervisedTask(x)
  catf("Classes: %i", m)
  catf(collapse(di, "\n"))
  catf("Positive class: %s", x$task.desc$positive)
}
