#' Returns a dataset containing standardized size-frequency data for all categories of species
#' @export
SF.STD.all = function() {
  ALL =
    rbind(
      SF.STD.TEMP,
      SF.STD.TROP,
      SF.STD.BILL,
      SF.STD.NERI,
      SF.STD.SEER,
      SF.STD.SHRK
    )

  if(exists("SF.STD.TNEI") & !is.null(SF.STD.TNEI)) ALL = rbind(ALL, SF.STD.TNEI)
  if(exists("SF.STD.ETPS") & !is.null(SF.STD.ETPS)) ALL = rbind(ALL, SF.STD.ETPS)
  if(exists("SF.STD.OTHR") & !is.null(SF.STD.OTHR)) ALL = rbind(ALL, SF.STD.OTHR)

  return(ALL)
}
