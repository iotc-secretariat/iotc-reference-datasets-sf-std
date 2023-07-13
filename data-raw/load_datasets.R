library(iotc.base.common.data)
library(iotc.base.common.std)
library(iotc.data.reference.datasets.SF.raw)
library(lubridate)

LAST_UPDATE = today(tzone = "UTC")
usethis::use_data(LAST_UPDATE, overwrite = TRUE)

SPECIES_CFG =
  query(
    connection = DB_IOTDB(),
    query = "
      SELECT
        Species AS SPECIES_CODE,
        StdSizeCode AS LENGTH_CODE,
        MaxStdSize AS MAX_SIZE,
        StdSizeClassInt AS STANDARD_BIN_SIZE,
        MaxSizeClassInt AS MAX_BIN_SIZE,
        FirstSizeClass AS FIRST_SIZE_CLASS
      FROM
        estSpecies")

standardize = function(sf_data) {
  first_species = TRUE

  STANDARDIZED_SF = NULL

  for(species in unique(sf_data$SPECIES_CODE)) {
    l_info(paste0("Processing S-F data for ", species))

    species_cfg = SPECIES_CFG[SPECIES_CODE == species]

    size_frequency = sf_data[SPECIES_CODE == species]

    if(nrow(size_frequency) == 0) {
      l_warn(paste0("No raw S-F data for ", species))
    } else {
      current_species_sf =
        standardize_size_frequencies(
          size_frequency,
          bin_size = species_cfg$STANDARD_BIN_SIZE,
          max_bin_size = species_cfg$MAX_BIN_SIZE,
          first_class_low = species_cfg$FIRST_SIZE_CLASS,
        )

      if(nrow(current_species_sf) > 0) {
        if(first_species) {
          STANDARDIZED_SF = current_species_sf
          first_species = FALSE
        } else
          STANDARDIZED_SF = rbind(STANDARDIZED_SF, current_species_sf)
      }
    }
  }

  return(STANDARDIZED_SF)
}

STD.BET = decorate(standardize(iotc.data.reference.datasets.SF.raw::RAW.BET), factorize = FALSE)
usethis::use_data(STD.BET, overwrite = TRUE, compress = "gzip")

STD.SKJ = decorate(standardize(iotc.data.reference.datasets.SF.raw::RAW.SKJ), factorize = FALSE)
usethis::use_data(STD.SKJ, overwrite = TRUE, compress = "gzip")

STD.YFT = decorate(standardize(iotc.data.reference.datasets.SF.raw::RAW.YFT), factorize = FALSE)
usethis::use_data(STD.YFT, overwrite = TRUE, compress = "gzip")

STD.TEMP = decorate(standardize(iotc.data.reference.datasets.SF.raw::RAW.TEMP), factorize = FALSE)
usethis::use_data(STD.TEMP, overwrite = TRUE, compress = "gzip")

STD.BILL = decorate(standardize(iotc.data.reference.datasets.SF.raw::RAW.BILL), factorize = FALSE)
usethis::use_data(STD.BILL, overwrite = TRUE, compress = "gzip")

STD.NERI = decorate(standardize(iotc.data.reference.datasets.SF.raw::RAW.NERI), factorize = FALSE)
usethis::use_data(STD.NERI, overwrite = TRUE, compress = "gzip")

STD.SEER = decorate(standardize(iotc.data.reference.datasets.SF.raw::RAW.SEER), factorize = FALSE)
usethis::use_data(STD.SEER, overwrite = TRUE, compress = "gzip")

#STD.TNEI = decorate(standardize(iotc.data.reference.datasets.SF.raw::RAW.TNEI), factorize = FALSE)
#usethis::use_data(STD.TNEI, overwrite = TRUE, compress = "gzip")

STD.SHRK = decorate(standardize(iotc.data.reference.datasets.SF.raw::RAW.SHRK), factorize = FALSE)
usethis::use_data(STD.SHRK, overwrite = TRUE, compress = "gzip")

#STD.OTHR = decorate(standardize(iotc.data.reference.datasets.SF.raw::RAW.OTHR), factorize = FALSE)
#usethis::use_data(STD.OTHR, overwrite = TRUE, compress = "gzip")

#STD.ETPS = decorate(standardize(iotc.data.reference.datasets.SF.raw::RAW.ETPS), factorize = FALSE)
#usethis::use_data(STD.ETPS, overwrite = TRUE, compress = "gzip")