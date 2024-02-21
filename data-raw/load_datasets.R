library(iotc.base.common.data)
library(iotc.base.common.std)
library(iotc.data.reference.datasets.SF.raw)

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

  STANDARDIZED_SF = decorate(STANDARDIZED_SF, factorize = FALSE)

  # What follows is required to add the 'MEASURE_UNIT_CODE' column in the right place
  # and ensure its values are all set to 'cm' (as we are standardizing the lengths of
  # each individual 'raw' SF record)

  ORDERED_COLUMNS = colnames(STANDARDIZED_SF)[1:35]
  ORDERED_COLUMNS = append(ORDERED_COLUMNS, "MEASURE_UNIT_CODE")
  ORDERED_COLUMNS = append(ORDERED_COLUMNS, colnames(STANDARDIZED_SF)[36:42])

  STANDARDIZED_SF$MEASURE_UNIT_CODE = "CM"

  setcolorder(STANDARDIZED_SF, ORDERED_COLUMNS)

  return(STANDARDIZED_SF)
}

STD.TROP = standardize(iotc.data.reference.datasets.SF.raw::RAW.TROP)
usethis::use_data(STD.TROP, overwrite = TRUE, compress = "gzip")

STD.TEMP = standardize(iotc.data.reference.datasets.SF.raw::RAW.TEMP)
usethis::use_data(STD.TEMP, overwrite = TRUE, compress = "gzip")

STD.BILL = standardize(iotc.data.reference.datasets.SF.raw::RAW.BILL)
usethis::use_data(STD.BILL, overwrite = TRUE, compress = "gzip")

STD.NERI = standardize(iotc.data.reference.datasets.SF.raw::RAW.NERI)
usethis::use_data(STD.NERI, overwrite = TRUE, compress = "gzip")

STD.SEER = standardize(iotc.data.reference.datasets.SF.raw::RAW.SEER)
usethis::use_data(STD.SEER, overwrite = TRUE, compress = "gzip")

STD.SHRK = standardize(iotc.data.reference.datasets.SF.raw::RAW.SHRK)
usethis::use_data(STD.SHRK, overwrite = TRUE, compress = "gzip")

LAST_UPDATE = Sys.Date()

METADATA = list(
  STD.SF = list(
    DATA = nrow(
      rbind(
        STD.TROP,
        STD.TEMP,
        STD.BILL,
        STD.NERI,
        STD.SEER,
        STD.SHRK
      )
    ),
    LAST_UPDATE = LAST_UPDATE
  )
)
usethis::use_data(METADATA, overwrite = TRUE, compress = "gzip")
