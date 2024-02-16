library(iotc.base.common.data)
library(iotc.base.common.std)

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
