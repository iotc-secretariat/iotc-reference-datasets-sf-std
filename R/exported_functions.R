#' Returns a dataset containing standardized size-frequency data for all categories of species
#' @export
all = function() {
  return(
    rbind(
      STD.BET,
      STD.SKJ,
      STD.YFT,
      STD.TEMP,
      STD.BILL,
      STD.NERI,
      STD.SEER,
      #STD.TNEI,
      STD.SHRK,
      #STD.OTHR,
      #STD.ETPS
    )
  )
}
