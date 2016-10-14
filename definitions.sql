create table `definitions`
select
  'dictionary' AS `source_dictionary`,
  `definitions_old`.`word_type`,
  `definitions_old`.`word_type_description`,
  `definitions_old`.`position`,
  `definitions_old`.`word`,
  NULL AS `synonymous`,
  TRIM(`definitions_old`.`definition`) AS `definition`,
  TRIM(`definitions_old`.`example`) AS `example`,
  'http://www.dictionary.com/' AS `url_source`,
  TRUE AS `canonical`
from
  `definitions_old`

UNION ALL

select
  `definitions_wordnik`.`source_dictionary` AS `source_dictionary`,
  `definitions_wordnik`.`part_of_speech` AS `word_type`,
  NULL AS `word_type_description`,
  `definitions_wordnik`.`sequence` AS `position`,
  `definitions_wordnik`.`word` AS `word`,
  NULL AS `synonymous`,
  TRIM(`definitions_wordnik`.`text_definition`) AS `definition`,
  NULL AS `example`,
  `definitions_wordnik`.`attribution_url` AS `url_source`,
  `definitions_wordnik`.`use_canonical` AS `canonical`
from
  `definitions_wordnik`

UNION ALL

select
  'wordnet' AS `source_dictionary`,
  `word_definitions`.`word_type`,
  NULL AS `word_type_description`,
  0 AS `position`,
  `word_definitions`.`word`,
  `word_definitions`.`synonymous`,
  TRIM( `word_definitions`.`definition`) AS `definition`,
  NULL AS `example`,
  'http://wordnet.princeton.edu/' AS `url_source`,
  true AS `canonical`
from
  `word_definitions`;
