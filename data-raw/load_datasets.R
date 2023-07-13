library(iotc.base.common.data)

SF_RAW_TEMP = SF.raw(species_category_codes = "TEMPERATE")
usethis::use_data(SF_RAW_TEMP, overwrite = TRUE)

SF_RAW_TROP = SF.raw(species_category_codes = "TROPICAL")
usethis::use_data(SF_RAW_TROP, overwrite = TRUE)

SF_RAW_BILL = SF.raw(species_category_codes = "BILLFISH")
usethis::use_data(SF_RAW_BILL, overwrite = TRUE)

SF_RAW_NERI = SF.raw(species_category_codes = "NERITIC")
usethis::use_data(SF_RAW_NERI, overwrite = TRUE)

SF_RAW_SEER = SF.raw(species_category_codes = "SEERFISH")
usethis::use_data(SF_RAW_SEER, overwrite = TRUE)

SF_RAW_TNEI = SF.raw(species_category_codes = "TUNAS_NEI")
usethis::use_data(SF_RAW_TNEI, overwrite = TRUE)

SF_RAW_SHRK = SF.raw(species_category_codes = c("SHARKS", "RAYS"))
usethis::use_data(SF_RAW_SHRK, overwrite = TRUE)

SF_RAW_OTHR = SF.raw(species_category_codes = c("OTHERS"))
usethis::use_data(SF_RAW_OTHR, overwrite = TRUE)

SF_RAW_ETPS = SF.raw(species_category_codes = c("CETACEANS", "SEABIRDS", "TURTLES"))
usethis::use_data(SF_RAW_ETPS, overwrite = TRUE)

SF_RAW_ALL =
  rbind(
    SF_RAW_TEMP,
    SF_RAW_TROP,
    SF_RAW_BILL,
    SF_RAW_NERI,
    SF_RAW_SEER,
    SF_RAW_TNEI,
    SF_RAW_SHRK,
    SF_RAW_OTHR,
    SF_RAW_ETPS
  )

unique(SF_RAW_BILL$MEASU[
