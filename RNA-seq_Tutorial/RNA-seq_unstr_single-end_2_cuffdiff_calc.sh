#!/bin/bash
#$ -S /bin/bash
#$ -cwd
#$ -soft -l ljob,lmem
#$ -l s_vmem=32G
#$ -l mem_req=32G

filename="RNA-seq_UPF1_Knockdown_Gencode"
gtfFile="/home/akimitsu/database/gencode.v19.annotation_filtered.gtf"

## Quantification
cuffdiff -p 8 --multi-read-correct -o ./cuffdiff_out_${filename} ${gtfFile} \
./tophat_out_SRR4081222_Control_1/accepted_hits.bam,./tophat_out_SRR4081223_Control_2/accepted_hits.bam,./tophat_out_SRR4081224_Control_3/accepted_hits.bam \
./tophat_out_SRR4081225_UPF1_knockdown_1/accepted_hits.bam,./tophat_out_SRR4081226_UPF1_knockdown_2/accepted_hits.bam,./tophat_out_SRR4081227_UPF1_knockdown_3/accepted_hits.bam

## Annotation
gene_list="/home/akimitsu/database/gencode.v19.annotation_filtered_symbol_type_list.txt" #Required
cuffnorm_data="gene_exp.diff"
# mRNA
gene_type="mRNA"
result_file="cuffdiff_result_mRNA.txt"
python ~/custom_command/cuffdiff_result.py ${gene_list} ./cuffdiff_out_${filename}/${cuffnorm_data} ${gene_type} ./cuffdiff_out_${filename}/${result_file}


# lncRNA
gene_type="lncRNA"
result_file="cuffdiff_result_lncRNA.txt"
python ~/custom_command/cuffdiff_result.py ${gene_list} ./cuffdiff_out_${filename}/${cuffnorm_data} ${gene_type} ./cuffdiff_out_${filename}/${result_file}
