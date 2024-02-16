library(iotc.base.common.data)
library(iotc.base.common.std)
<<<<<<< HEAD

ALL_SPECIES =
  query(
    connection = DB_IOTDB(),
    query = "
    SELECT DISTINCT  --DISTINCT added by manu 24/04/2023
      E.[Group] AS SPECIES_GROUP_CODE,
      E.Species AS SPECIES_CODE,
      S.NAME_EN AS SPECIES_NAME_EN,
      S.NAME_LT AS SPECIES_SCIENTIFIC_NAME,
      E.StdSizeCode AS LENGTH_CODE,
      CASE
        WHEN E.StdSizeCode = 'FL' THEN 'Fork length'
        WHEN E.StdSizeCode = 'EFL' THEN 'Eye-fork length'
  	  ELSE
        M.EngDescr
    	END AS LENGTH_NAME_EN,
      E.MaxStdSize AS MAX_SIZE,
      E.StdSizeClassInt AS STANDARD_BIN_SIZE,
      E.MaxSizeClassInt AS MAX_BIN_SIZE,
      E.FirstSizeClass AS FIRST_SIZE_CLASS
    FROM
      estSpecies E
    LEFT JOIN
      [IOTDB].[meta].SPECIES S
    ON
      E.Species = S.CODE
    LEFT JOIN
    	[IOTDB].[dbo].cdeMeasTypes M
    ON
    	E.StdSizeCode = M.ACode
    WHERE
      --S.IOTDB_CODE IN ('BET', 'SKJ', 'YFT') AND
      S.IOTDB_CODE NOT IN ('SKJS', 'SKJM', 'SKJL',
                           'YFTS', 'YFTM', 'YFTL')
    ")

process_species = function(dataset) {
  all_species = unique(dataset$SPECIES_CODE)

  standardized_dataset = NULL

  for(species in all_species) {
    species_data = dataset[SPECIES_CODE == species]

    if(species %in% ALL_SPECIES$SPECIES_CODE) {
      standardized_species_data =
        standardize_and_pivot_size_frequencies(
          species_data,
          bin_size        = ALL_SPECIES[SPECIES_CODE == species]$STANDARD_BIN_SIZE,
          max_bin_size    = ALL_SPECIES[SPECIES_CODE == species]$MAX_BIN_SIZE,
          first_class_low = ALL_SPECIES[SPECIES_CODE == species]$FIRST_SIZE_CLASS
        )

      if(is.null(standardized_dataset))
        standardized_dataset = standardized_species_data
      else
        standardized_dataset = rbind(standardized_dataset, standardized_species_data)
    }
  }

  return(standardized_dataset)
}

SF.STD.TEMP = process_species(SF.raw(species_category_codes = "TEMPERATE"))
usethis::use_data(SF.STD.TEMP, overwrite = TRUE, compress = "gzip")

SF.STD.TROP = process_species(SF.raw(species_category_codes = "TROPICAL"))
usethis::use_data(SF.STD.TROP, overwrite = TRUE, compress = "gzip")

SF.STD.BILL = process_species(SF.raw(species_category_codes = "BILLFISH"))
usethis::use_data(SF.STD.BILL, overwrite = TRUE, compress = "gzip")

SF.STD.NERI = process_species(SF.raw(species_category_codes = "NERITIC"))
usethis::use_data(SF.STD.NERI, overwrite = TRUE, compress = "gzip")

SF.STD.SEER = process_species(SF.raw(species_category_codes = "SEERFISH"))
usethis::use_data(SF.STD.SEER, overwrite = TRUE, compress = "gzip")

SF.STD.TNEI = process_species(SF.raw(species_category_codes = "TUNAS_NEI"))
if(!is.null(SF.STD.TNEI)) usethis::use_data(SF.STD.TNEI, overwrite = TRUE, compress = "gzip")

SF.STD.SHRK = process_species(SF.raw(species_category_codes = c("SHARKS", "RAYS")))
usethis::use_data(SF.STD.SHRK, overwrite = TRUE, compress = "gzip")

SF.STD.ETPS = process_species(SF.raw(species_category_codes = c("CETACEANS", "SEABIRDS", "TURTLES")))
if(!is.null(SF.STD.ETPS)) usethis::use_data(SF.STD.ETPS, overwrite = TRUE, compress = "gzip")

SF.STD.OTHR = process_species(SF.raw(species_category_codes = c("OTHERS")))
if(!is.null(SF.STD.OTHR)) usethis::use_data(SF.STD.OTHR, overwrite = TRUE, compress = "gzip")

LAST_UPDATE = Sys.Date()
usethis::use_data(LAST_UPDATE, overwrite = TRUE, compress = "gzip")
=======
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
>>>>>>> d1a37bf2383f213b692c694539ed3abedc06c76f
