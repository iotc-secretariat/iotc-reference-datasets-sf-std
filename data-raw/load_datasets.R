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
          bin_size        = species_cfg$STANDARD_BIN_SIZE,
          max_bin_size    = species_cfg$MAX_BIN_SIZE,
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

SF.STD.TEMP = decorate(standardize(iotc.data.reference.datasets.SF.raw::SF.RAW.TEMP), factorize = FALSE)
usethis::use_data(SF.STD.TEMP, overwrite = TRUE, compress = "gzip")

SF.STD.TROP = decorate(standardize(iotc.data.reference.datasets.SF.raw::SF.RAW.TROP), factorize = FALSE)
usethis::use_data(SF.STD.TROP, overwrite = TRUE, compress = "gzip")

SF.STD.BILL = decorate(standardize(iotc.data.reference.datasets.SF.raw::SF.RAW.BILL), factorize = FALSE)
usethis::use_data(SF.STD.BILL, overwrite = TRUE, compress = "gzip")

SF.STD.NERI = decorate(standardize(iotc.data.reference.datasets.SF.raw::SF.RAW.NERI), factorize = FALSE)
usethis::use_data(SF.STD.NERI, overwrite = TRUE, compress = "gzip")

SF.STD.SEER = decorate(standardize(iotc.data.reference.datasets.SF.raw::SF.RAW.SEER), factorize = FALSE)
usethis::use_data(SF.STD.SEER, overwrite = TRUE, compress = "gzip")

SF.STD.SHRK = decorate(standardize(iotc.data.reference.datasets.SF.raw::SF.RAW.SHRK), factorize = FALSE)
usethis::use_data(SF.STD.SHRK, overwrite = TRUE, compress = "gzip")
