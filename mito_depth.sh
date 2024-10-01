#!/bin/bash

BAM_ARRAY=( $(find /local/fatbob/Resequencing_Fulleri_2022/mito/remove_dups/mito/ -name '*bam') )
GENOME=/local/fatbob/Resequencing_Fulleri_2022/mito/Corydoras_trilineatus_mito.fa

for BAM in ${BAM_ARRAY[@]}; do
  SAMPLE_NAME=$(echo $BAM | awk -F"/" '{print $(NF)}' | sed 's/_remove_dups.bam//g' )
  samtools depth -aa  ${BAM} --reference ${GENOME} > ${SAMPLE_NAME}'_depth.txt'
done
