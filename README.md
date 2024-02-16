# Standardized size-frequency datasets

This R project is used to build the `iotc.data.reference.datasets.SF.std` R package and contains all necessary code and resources to create the **standardized** size-frequency datasets for all species for which there is any type of length or weight measurement available in the IOTC databases **and** the corresponding conversion equations towards the species-specific default size measurements.

It uses the `iotc.base.common.data` library to access the current data storage (`IOTDB`) but does not explicitly depends on it. This means that the final package can be used in other R projects / scripts that need any of the exported datasets, without introducing any type of dependency from the IOTC databases.

In fact, *live* access to the IOTC databases is only required when **building** the project.

Likewise, the project uses the `iotc.data.reference.datasets.SF.raw` and `iotc.base.common.std` packages to access the raw size frequency data and the size-frequency standardization functions included in the IOTC libraries, but only at build time.

## How to initialise the datasets

Simply run the `load_datasets.R` script included under the `data-raw` folder.

The script will take care of:

- loading the species-specific size-frequency configuration for the most significant species
- *decorating* the **raw** size-frequency data exported by the `iotc.data.reference.datasets.SF.raw` package
- standardizing the size-frequency data for each species group
- producing a distinct `.rda` R data file for each species group, eventually stored under the `data` folder of the project
- uploading the `.rda` files onto the [_Downloads_ section](https://bitbucket.org/iotc-ws/iotc-reference-datasets-sf-std/downloads/) of the BitBucket repository

## How to build the package

From within a R session run:

```         
devtools::document(roclets = c('rd', 'collate', 'namespace'))
devtools::build()
```

or select `Build` / `Build source package` from within R studio

At the end of the installation, the script uploads the artifacts (i.e., the R data files) onto the [Download](https://bitbucket.org/iotc-ws/iotc-reference-datasets-sf-std/downloads/) section of the BitBucket repository.

For this to work, it is necessary to configure in advance the `BITBUCKET_UPLOAD_SF_STD_DATASET_TOKEN` as an environment variable that should be assigned an access token created for the specific repository (with the `repository:write` OAuth 2.0 scope).

The creation of the token is generally [performed by the repository administrators](https://support.atlassian.com/bitbucket-cloud/docs/create-a-repository-access-token/) and the tokens, once created, shall be stored securely as they won't be accessible again after the creation.

See also the specific section of the [BitBucket cloud REST API](https://developer.atlassian.com/cloud/bitbucket/rest/api-group-downloads/#api-repositories-workspace-repo-slug-downloads-post).

## How to install the package

Build the package first, then from a command shell run:

```         
Rcmd.exe INSTALL --preclean --no-multiarch --with-keep.source iotc-reference-datasets-sf-std
```

or select `Build` / `Install package` from within R studio

## Publicly exported package content

### Datasets

1.  `STD.TEMP` - raw size-frequency data for temperate tunas (**albacore** and **southern bluefin tuna**)
2.  `STD.TROP` - raw size-frequency data for tropical tunas (**bigeye tuna**, **skipjack tuna**, and **yellowfin tuna**)
3.  `STD.BILL` - raw size-frequency data for billfish species (**black marlin**, **blue marlin**, **striped marlin**, **Indo-pacific sailfish**, and **swordfish**)
4.  `STD.NERI` - raw size-frequency data for neritic tunas (**bullet tuna**, **frigate tuna**, **kawakawa**, and **longtail tuna**)
5.  `STD.SEER` - raw size-frequency data for seerfish species (**Indo-pacific king mackerel** and **narrow-barred Spanish mackerel**)
6.  `STD.SHRK` - raw size-frequency data for **sharks**, **rays**, and **mobulid** species
7.  `LAST_UPDATE` - the date of last update / production of the datasets

Standardized size-frequency datasets **ARE NOT** produced for:

-   tunas (NEI),
-   ETP species, and
-   all "*other*" species

due to the lack of proper conversion equations.

### Functions

1.  `STD.all()` - to return a collation of all `STD.*` datasets above

## Structure of the datasets

-   `YEAR` \< *to be described* \>
-   `QUARTER` \< *to be described* \>
-   `MONTH_START` \< *to be described* \>
-   `MONTH_END` \< *to be described* \>
-   `FISHING_GROUND_CODE` \< *to be described* \>
-   `FISHING_GROUND` \< *to be described* \>
-   `FLEET_CODE` \< *to be described* \>
-   `FLEET` \< *to be described* \>
-   `FISHERY_TYPE_CODE` \< *to be described* \>
-   `FISHERY_TYPE` \< *to be described* \>
-   `FISHERY_GROUP_CODE` \< *to be described* \>
-   `FISHERY_GROUP` \< *to be described* \>
-   `FISHERY_CODE` \< *to be described* \>
-   `FISHERY` \< *to be described* \>
-   `GEAR_CODE` \< *to be described* \>
-   `GEAR` \< *to be described* \>
-   `SCHOOL_TYPE_CODE` \< *to be described* \>
-   `IUCN_STATUS_CODE` \< *to be described* \>
-   `IUCN_STATUS` \< *to be described* \>
-   `SPECIES_WP_CODE` \< *to be described* \>
-   `SPECIES_WP` \< *to be described* \>
-   `SPECIES_GROUP_CODE` \< *to be described* \>
-   `SPECIES_GROUP` \< *to be described* \>
-   `SPECIES_CATEGORY_CODE` \< *to be described* \>
-   `SPECIES_CATEGORY` \< *to be described* \>
-   `SPECIES_CODE` \< *to be described* \>
-   `SPECIES` \< *to be described* \>
-   `SPECIES_SCIENTIFIC` \< *to be described* \>
-   `SPECIES_FAMILY` \< *to be described* \>
-   `SPECIES_ORDER` \< *to be described* \>
-   `IS_IOTC_SPECIES` \< *to be described* \>
-   `IS_SPECIES_AGGREGATE` \< *to be described* \>
-   `IS_SSI` \< *to be described* \>
-   `MEASURE_TYPE_CODE` \< *to be described* \>
-   `MEASURE_TYPE` \< *to be described* \>
-   `MEASURE_UNIT_CODE` \< *to be described* \>
-   `WEIGHT` \< *to be described* \>
-   `SEX_CODE` \< *to be described* \>
-   `CLASS_LOW` \< *to be described* \>
-   `CLASS_HIGH` \< *to be described* \>
-   `FISH_COUNT` \< *to be described* \>
-   `RAISING` \< *to be described* \>
-   `RAISE_CODE` \< *to be described* \>

The `MEASURE_UNIT_CODE` column is *synthetic*, i.e., added *a posteriori* and fixed to `cm`, as the `MEASURE_TYPE_CODE` in the standardized size-frequency datasets is always a length.

Note also how there is no `WEIGHT_UNIT_CODE` column, as the estimated `WEIGHT` is:

-   Assumed to be *round weight*
-   Assumed to be in kilograms by default
