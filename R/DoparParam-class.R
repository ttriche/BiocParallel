.DoparParam <- setClass("DoparParam",
    representation(),
    prototype(),
    contains = "BiocParallelParam")

.DoparParamSingleton <- .DoparParam()

DoparParam <- function() .DoparParamSingleton

.doParBackendRegistered <- function() {
    "package:foreach" %in% search() && getDoParRegistered() &&
        getDoParName() != "doSEQ" && getDoParWorkers() > 1
}

## control

setMethod(bpworkers, "DoparParam",
    function(param, ...)
{
    if (bpisup(param))
        getDoParWorkers()
    else 0L
})

setMethod(bpisup, "DoparParam",
    function(param, ...)
{
    ("package:foreach" %in% search()) &&
        getDoParRegistered() && (getDoParName() != "doSEQ") &&
            getDoParWorkers() > 1L
})

## evaluation

setMethod(bplapply, c("ANY", "ANY", "DoparParam"),
    function(X, FUN, ..., param)
{
    FUN <- match.fun(FUN)
    ## If no parallel backend is registered for foreach, fall back to
    ## the serial backend.
    if (!bpisup(param))
        return(bplapply(X, FUN, ..., param=SerialParam()))

    x <- NULL                           # quieten R CMD check
    ans <- foreach(x=X) %dopar% FUN(x, ...)
    setNames(ans, names(X))
})