#!/bin/bash

#-------------------------------------------------------------

GENO=$1
PHENO=$2

echo -e "\n-----------------------------------------------------"
echo "Convert text to binary format"
echo "-----------------------------------------------------"
CMM="plink --file $GENO --make-bed --out $GENO-1"
echo -e "\n>>> " $CMM "\n"
eval $CMM
plink --bfile $GENO-1 --recode tab --out $GENO-1

echo ""
echo "-----------------------------------------------------"
echo "Filter missingness per sample"
echo "-----------------------------------------------------"
CMM="plink --bfile $GENO-1 --mind 0.1 --make-bed --out $GENO-2"
echo -e "\n>>> " $CMM "\n"
eval $CMM
plink --bfile $GENO-2 --recode tab --out $GENO-2

echo ""
echo "-----------------------------------------------------"
echo "Filter missingness per SNP"
echo "-----------------------------------------------------"
CMM="plink --bfile $GENO-2 --geno 0.1 --make-bed --out $GENO-3"
echo -e "\n>>> " $CMM "\n"
eval $CMM
plink --bfile $GENO-3 --recode tab --out $GENO-3

echo ""
echo "-----------------------------------------------------"
echo " Filter SNPs with a low minor allele frequency (MAF)"
echo "-----------------------------------------------------"
CMM="plink --bfile $GENO-3 --maf 0.01 --make-bed --out $GENO-4"
echo -e "\n>>> " $CMM "\n"
eval $CMM
plink --bfile $GENO-4 --recode tab --out $GENO-4

echo ""
echo "-----------------------------------------------------"
echo " Filter SNPs which are not in Hardy-Weinberg equilibrium (HWE)."
echo "-----------------------------------------------------"
CMM="plink --bfile $GENO-4 --hwe 1e-10 --make-bed --out $GENO-5"
echo -e "\n>>> " $CMM "\n"
eval $CMM
plink --bfile $GENO-5 --recode tab --out $GENO-5


echo ""
echo "-----------------------------------------------------"
echo " Filter individuals closely related (Cryptic relatedness)"
echo "-----------------------------------------------------"
CMM="plink --bfile $GENO-5 --genome --min 0.0001 --make-bed --out $GENO-6"
echo -e "\n>>> " $CMM "\n"
eval $CMM
plink --bfile $GENO-6 --recode tab --out $GENO-6


echo ""
echo "-----------------------------------------------------"
echo " Filter phenotype to .ped Individuals"
echo "-----------------------------------------------------"
CMM="Rscript filter-pheno-from-ped.R $PHENO $GENO-6.ped"
echo -e "\n>>> " $CMM "\n"
eval $CMM

echo ""
echo "-----------------------------------------------------"
echo " Get final markers and individuals"
echo "-----------------------------------------------------"
CMM="cut -f 2 $GENO-6.ped > filtered-individuals.tbl"
echo -e "\n>>> " $CMM "\n"
eval $CMM
CMM="cut -f 2 $GENO-6.map > filtered-markers.tbl"
echo -e "\n>>> " $CMM "\n"
eval $CMM


