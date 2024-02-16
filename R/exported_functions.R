#' Returns a dataset containing standardized size-frequency data for all categories of species
#' @export
STD.all = function() {
  ALL =
    rbind(
      STD.TEMP,
      STD.TROP,
      STD.BILL,
      STD.NERI,
      STD.SEER,
      STD.SHRK
    )

  if(exists("STD.TNEI") & !is.null(STD.TNEI)) ALL = rbind(ALL, STD.TNEI)
  if(exists("STD.ETPS") & !is.null(STD.ETPS)) ALL = rbind(ALL, STD.ETPS)
  if(exists("STD.OTHR") & !is.null(STD.OTHR)) ALL = rbind(ALL, STD.OTHR)

  return(ALL)
}
