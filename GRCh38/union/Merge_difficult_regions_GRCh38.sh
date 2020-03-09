#!/bin/sh

#  Merge_difficult_regions.sh
#  
#
#  Created by Zook, Justin on 12/11/18.
#
#  Updated by Zook, Justin on 1/7/19 to make everything reproducible and include v4.1 for HG002

#merge other difficult regions (need to use subtractbed for vdj because it didn't work with multiintersectbed)
/Volumes/DroboZook/bioinfo/bedtools2.25.0/bin/multiIntersectBed -i /Volumes/giab/analysis/GRCh38_stratification_bed_files/OtherDifficult/GCA_000001405.15_GRCh38_no_alt_plus_hs38d1_analysis_set_REF_N_slop_15kb.bed /Volumes/giab/analysis/GRCh38_stratification_bed_files/OtherDifficult/hg38.contigs.1-22.lt_500kb.bed /Volumes/giab/analysis/GRCh38_stratification_bed_files/OtherDifficult/hg38.rmsk.L1H_gt500.bed /Volumes/giab/analysis/GRCh38_stratification_bed_files/OtherDifficult/MHC_GRCh38.bed  | grep -v 'gl\|hap\|MT' | /Volumes/DroboZook/bioinfo/bedtools2.25.0/bin/mergeBed -i stdin | /Volumes/DroboZook/bioinfo/bedtools2.25.0/bin/subtractBed -a /Volumes/giab/analysis/GRCh38_stratification_bed_files/LowComplexity/intermediatefiles/human.b38.genome.bed -b stdin | /Volumes/DroboZook/bioinfo/bedtools2.25.0/bin/subtractBed -a stdin -b /Volumes/giab/analysis/GRCh38_stratification_bed_files/OtherDifficult/hg38.vdj.bed | /Volumes/DroboZook/bioinfo/bedtools2.25.0/bin/subtractBed -a /Volumes/giab/analysis/GRCh38_stratification_bed_files/LowComplexity/intermediatefiles/human.b38.genome.bed -b stdin | /Volumes/DroboZook/bioinfo/htslib-1.3.2/bgzip -c > /Volumes/giab/analysis/GRCh38_stratification_bed_files/OtherDifficult/GRCh38_allOtherDifficultregions.bed.gz
#merge all low mappable and seg dup regions
/Volumes/DroboZook/bioinfo/bedtools2.25.0/bin/multiIntersectBed -i /Volumes/giab/analysis/GRCh38_stratification_bed_files/mappability/lowmappabilityall.bed.gz /Volumes/giab/analysis/GRCh38_stratification_bed_files/SegmentalDuplications/hg38.segdups_sorted_merged.bed.gz | grep -v 'gl\|hap\|MT' | /Volumes/DroboZook/bioinfo/bedtools2.25.0/bin/mergeBed -i stdin | /Volumes/DroboZook/bioinfo/htslib-1.3.2/bgzip -c > /Volumes/giab/analysis/GRCh38_stratification_bed_files/GRCh38_alllowmapandsegdupregions.bed.gz
/Volumes/DroboZook/bioinfo/bedtools2.25.0/bin/subtractBed -a /Volumes/giab/analysis/GRCh38_stratification_bed_files/LowComplexity/intermediatefiles/human.b38.genome.bed -b /Volumes/giab/analysis/GRCh38_stratification_bed_files/GRCh38_alllowmapandsegdupregions.bed.gz | /Volumes/DroboZook/bioinfo/htslib-1.3.2/bgzip -c > /Volumes/giab/analysis/GRCh38_stratification_bed_files/GRCh38_notinalllowmapandsegdupregions.bed.gz
#merge all difficult regions
/Volumes/DroboZook/bioinfo/bedtools2.25.0/bin/multiIntersectBed -i /Volumes/giab/analysis/GRCh38_stratification_bed_files/mappability/lowmappabilityall.bed.gz /Volumes/giab/analysis/GRCh38_stratification_bed_files/GCcontent/GRCh38_l100_gclt25orgt65_slop50.bed.gz /Volumes/giab/analysis/GRCh38_stratification_bed_files/LowComplexity/GRCh38_AllTandemRepeatsandHomopolymers_slop5.bed.gz /Volumes/giab/analysis/GRCh38_stratification_bed_files/SegmentalDuplications/hg38.segdups_sorted_merged.bed.gz /Volumes/giab/analysis/GRCh38_stratification_bed_files/FunctionalTechnicallyDifficultRegions/GRCh38_remapped_BadPromoters_gb-2013-14-5-r51-s1.bed.gz /Volumes/giab/analysis/GRCh38_stratification_bed_files/OtherDifficult/GRCh38_allOtherDifficultregions.bed.gz | grep -v 'gl\|hap\|MT' | /Volumes/DroboZook/bioinfo/bedtools2.25.0/bin/mergeBed -i stdin | /Volumes/DroboZook/bioinfo/htslib-1.3.2/bgzip -c > /Volumes/giab/analysis/GRCh38_stratification_bed_files/GRCh38_alldifficultregions.bed.gz

/Volumes/DroboZook/bioinfo/bedtools2.25.0/bin/subtractBed -a /Volumes/giab/analysis/GRCh38_stratification_bed_files/LowComplexity/intermediatefiles/human.b38.genome.bed -b /Volumes/giab/analysis/GRCh38_stratification_bed_files/GRCh38_alldifficultregions.bed.gz | /Volumes/DroboZook/bioinfo/htslib-1.3.2/bgzip -c > /Volumes/giab/analysis/GRCh38_stratification_bed_files/GRCh38_notinalldifficultregions.bed.gz


gunzip -c /Volumes/giab/analysis/GRCh38_stratification_bed_files/mappability/lowmappabilityall.bed.gz | awk '{sum+=$3-$2} END {print sum}' 
#402265532
gunzip -c /Volumes/giab/analysis/GRCh38_stratification_bed_files/GCcontent/GRCh38_l100_gclt25orgt65_slop50.bed.gz| awk '{sum+=$3-$2} END {print sum}' 
#191797009
gunzip -c /Volumes/giab/analysis/GRCh38_stratification_bed_files/LowComplexity/GRCh38_AllTandemRepeatsandHomopolymers_slop5.bed.gz | awk '{sum+=$3-$2} END {print sum}' 
#250089957
gunzip -c /Volumes/giab/analysis/GRCh38_stratification_bed_files/SegmentalDuplications/hg38.segdups_sorted_merged.bed.gz | awk '{sum+=$3-$2} END {print sum}' 
#166497144
gunzip -c /Volumes/giab/analysis/GRCh38_stratification_bed_files/GRCh38_alldifficultregions.bed.gz | awk '{sum+=$3-$2} END {print sum}' 
#774331025
gunzip -c /Volumes/giab/analysis/GRCh38_stratification_bed_files/GRCh38_notinalldifficultregions.bed.gz | awk '{sum+=$3-$2} END {print sum}' 
#2313955375


#merge genomespecific and alldifficultregions
/Volumes/DroboZook/bioinfo/bedtools2.25.0/bin/multiIntersectBed -i /Volumes/giab/analysis/GRCh38_stratification_bed_files/GRCh38_alldifficultregions.bed.gz  /Volumes/giab/analysis/GRCh38_stratification_bed_files/GenomeSpecific/HG001_NA12878/GIABv3.3.2/GRCh38_remapped_HG001_genomespecific_complexandSVs_v3.3.2_PG_RTG.bed.gz  | /Volumes/DroboZook/bioinfo/bedtools2.25.0/bin/mergeBed -i stdin | /Volumes/DroboZook/bioinfo/htslib-1.3.2/bgzip -c > /Volumes/giab/analysis/GRCh38_stratification_bed_files/GenomeSpecific/HG001_NA12878/HG001_genomespecific_RTG_PG_v3.3.2_SVs_alldifficultregions.bed.gz 
/Volumes/DroboZook/bioinfo/bedtools2.25.0/bin/subtractBed -a /Volumes/giab/analysis/GRCh38_stratification_bed_files/LowComplexity/intermediatefiles/human.b38.genome.bed -b /Volumes/giab/analysis/GRCh38_stratification_bed_files/GenomeSpecific/HG001_NA12878/HG001_genomespecific_RTG_PG_v3.3.2_SVs_alldifficultregions.bed.gz | /Volumes/DroboZook/bioinfo/htslib-1.3.2/bgzip -c > /Volumes/giab/analysis/GRCh38_stratification_bed_files/GenomeSpecific/HG001_NA12878/notinHG001_genomespecific_RTG_PG_v3.3.2_SVs_alldifficultregions.bed.gz 

/Volumes/DroboZook/bioinfo/bedtools2.25.0/bin/multiIntersectBed -i /Volumes/giab/analysis/GRCh38_stratification_bed_files/GRCh38_alldifficultregions.bed.gz /Volumes/giab/analysis/GRCh38_stratification_bed_files/GenomeSpecific/HG002/GIABv3.3.2/GRCh38_remapped_HG002_genomespecific_complexandSVs_v3.3.2.bed.gz  | /Volumes/DroboZook/bioinfo/bedtools2.25.0/bin/mergeBed -i stdin | /Volumes/DroboZook/bioinfo/htslib-1.3.2/bgzip -c > /Volumes/giab/analysis/GRCh38_stratification_bed_files/GenomeSpecific/HG002/GIABv3.3.2/HG002_genomespecific_complexandSVs_alldifficultregions_v3.3.2.bed.gz 
/Volumes/DroboZook/bioinfo/bedtools2.25.0/bin/subtractBed -a /Volumes/giab/analysis/GRCh38_stratification_bed_files/LowComplexity/intermediatefiles/human.b38.genome.bed -b /Volumes/giab/analysis/GRCh38_stratification_bed_files/GenomeSpecific/HG002/GIABv3.3.2/HG002_genomespecific_complexandSVs_alldifficultregions_v3.3.2.bed.gz | /Volumes/DroboZook/bioinfo/htslib-1.3.2/bgzip -c > /Volumes/giab/analysis/GRCh38_stratification_bed_files/GenomeSpecific/HG002/GIABv3.3.2/notinHG002_genomespecific_complexandSVs_alldifficultregions_v3.3.2.bed.gz 

/Volumes/DroboZook/bioinfo/bedtools2.25.0/bin/multiIntersectBed -i /Volumes/giab/analysis/GRCh38_stratification_bed_files/GRCh38_alldifficultregions.bed.gz /Volumes/giab/analysis/GRCh38_stratification_bed_files/GenomeSpecific/HG002/GIABv4.1/HG002_genomespecific_complexandSVs_v4.1.bed.gz  | /Volumes/DroboZook/bioinfo/bedtools2.25.0/bin/mergeBed -i stdin | /Volumes/DroboZook/bioinfo/htslib-1.3.2/bgzip -c > /Volumes/giab/analysis/GRCh38_stratification_bed_files/GenomeSpecific/HG002/GIABv4.1/HG002_genomespecific_complexandSVs_alldifficultregions_v4.1.bed.gz 
/Volumes/DroboZook/bioinfo/bedtools2.25.0/bin/subtractBed -a /Volumes/giab/analysis/GRCh38_stratification_bed_files/LowComplexity/intermediatefiles/human.b38.genome.bed -b /Volumes/giab/analysis/GRCh38_stratification_bed_files/GenomeSpecific/HG002/GIABv4.1/HG002_genomespecific_complexandSVs_alldifficultregions_v4.1.bed.gz | /Volumes/DroboZook/bioinfo/htslib-1.3.2/bgzip -c > /Volumes/giab/analysis/GRCh38_stratification_bed_files/GenomeSpecific/HG002/GIABv4.1/notinHG002_genomespecific_complexandSVs_alldifficultregions_v4.1.bed.gz 

/Volumes/DroboZook/bioinfo/bedtools2.25.0/bin/multiIntersectBed -i /Volumes/giab/analysis/GRCh38_stratification_bed_files/GRCh38_alldifficultregions.bed.gz /Volumes/giab/analysis/GRCh38_stratification_bed_files/GenomeSpecific/HG003/GIABv3.3.2/GRCh38_remapped_HG003_genomespecific_complexandSVs_v3.3.2.bed.gz  | /Volumes/DroboZook/bioinfo/bedtools2.25.0/bin/mergeBed -i stdin | /Volumes/DroboZook/bioinfo/htslib-1.3.2/bgzip -c > /Volumes/giab/analysis/GRCh38_stratification_bed_files/GenomeSpecific/HG003/GIABv3.3.2/HG003_genomespecific_complexandSVs_alldifficultregions_v3.3.2.bed.gz 
/Volumes/DroboZook/bioinfo/bedtools2.25.0/bin/subtractBed -a /Volumes/giab/analysis/GRCh38_stratification_bed_files/LowComplexity/intermediatefiles/human.b38.genome.bed -b /Volumes/giab/analysis/GRCh38_stratification_bed_files/GenomeSpecific/HG003/GIABv3.3.2/HG003_genomespecific_complexandSVs_alldifficultregions_v3.3.2.bed.gz | /Volumes/DroboZook/bioinfo/htslib-1.3.2/bgzip -c > /Volumes/giab/analysis/GRCh38_stratification_bed_files/GenomeSpecific/HG003/GIABv3.3.2/notinHG003_genomespecific_complexandSVs_alldifficultregions_v3.3.2.bed.gz 

/Volumes/DroboZook/bioinfo/bedtools2.25.0/bin/multiIntersectBed -i /Volumes/giab/analysis/GRCh38_stratification_bed_files/GRCh38_alldifficultregions.bed.gz /Volumes/giab/analysis/GRCh38_stratification_bed_files/GenomeSpecific/HG004/GIABv3.3.2/GRCh38_remapped_HG004_genomespecific_complexandSVs_v3.3.2.bed.gz  | /Volumes/DroboZook/bioinfo/bedtools2.25.0/bin/mergeBed -i stdin | /Volumes/DroboZook/bioinfo/htslib-1.3.2/bgzip -c > /Volumes/giab/analysis/GRCh38_stratification_bed_files/GenomeSpecific/HG004/GIABv3.3.2/HG004_genomespecific_complexandSVs_alldifficultregions_v3.3.2.bed.gz 
/Volumes/DroboZook/bioinfo/bedtools2.25.0/bin/subtractBed -a /Volumes/giab/analysis/GRCh38_stratification_bed_files/LowComplexity/intermediatefiles/human.b38.genome.bed -b /Volumes/giab/analysis/GRCh38_stratification_bed_files/GenomeSpecific/HG004/GIABv3.3.2/HG004_genomespecific_complexandSVs_alldifficultregions_v3.3.2.bed.gz | /Volumes/DroboZook/bioinfo/htslib-1.3.2/bgzip -c > /Volumes/giab/analysis/GRCh38_stratification_bed_files/GenomeSpecific/HG004/GIABv3.3.2/notinHG004_genomespecific_complexandSVs_alldifficultregions_v3.3.2.bed.gz 

/Volumes/DroboZook/bioinfo/bedtools2.25.0/bin/multiIntersectBed -i /Volumes/giab/analysis/GRCh38_stratification_bed_files/GRCh38_alldifficultregions.bed.gz /Volumes/giab/analysis/GRCh38_stratification_bed_files/GenomeSpecific/HG005/GIABv3.3.2/GRCh38_remapped_HG005_genomespecific_complexandSVs_v3.3.2.bed.gz  | /Volumes/DroboZook/bioinfo/bedtools2.25.0/bin/mergeBed -i stdin | /Volumes/DroboZook/bioinfo/htslib-1.3.2/bgzip -c > /Volumes/giab/analysis/GRCh38_stratification_bed_files/GenomeSpecific/HG005/GIABv3.3.2/HG005_genomespecific_complexandSVs_alldifficultregions_v3.3.2.bed.gz 
/Volumes/DroboZook/bioinfo/bedtools2.25.0/bin/subtractBed -a /Volumes/giab/analysis/GRCh38_stratification_bed_files/LowComplexity/intermediatefiles/human.b38.genome.bed -b /Volumes/giab/analysis/GRCh38_stratification_bed_files/GenomeSpecific/HG005/GIABv3.3.2/HG005_genomespecific_complexandSVs_alldifficultregions_v3.3.2.bed.gz | /Volumes/DroboZook/bioinfo/htslib-1.3.2/bgzip -c > /Volumes/giab/analysis/GRCh38_stratification_bed_files/GenomeSpecific/HG005/GIABv3.3.2/notinHG005_genomespecific_complexandSVs_alldifficultregions_v3.3.2.bed.gz 
