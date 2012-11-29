splitIndices <- parallel::splitIndices

.onLoad <-
    function(libname, pkgname)
{
    ## only SnowParam on widows, which is then the default (first)
    register(getOption("SnowParam", SnowParam(spec=0L)))
    if (.Platform$OS.type != "windows")
        register(getOption("MulticoreParam", MulticoreParam()))
}