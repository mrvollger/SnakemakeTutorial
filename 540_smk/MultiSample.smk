import os
import sys

shell.prefix("set -euo pipefail; ")
# why you should always have this at the start of bash scripts
# https://vaneyckt.io/posts/safer_bash_scripts_with_set_euxo_pipefail/
# you can also add a source command here to set up you env. 


samples = ["A", "B", "C"]

rule all:
	input:
		bam = "mapped_reads/A.bam"

#		bam = expand("mapped_reads/{sm}.bam", sm = samples)


rule bwa_index:
	input:
		ref = "data/genome.fa"
	output:
		amb = "data/genome.fa.amb",
		ann = "data/genome.fa.ann",
		bwt = "data/genome.fa.bwt",
		pac = "data/genome.fa.pac",
		sa =   "data/genome.fa.sa"
	shell:
		"bwa index {input.ref}"


rule bwa_map:
	input:
		ref = "data/genome.fa",
		index = rules.bwa_index.output,
		reads = "data/samples/{sm}.fastq"
	output:
		sam = temp("mapped_reads/{sm}.unsorted.sam")
	shell:
		"bwa mem {input.ref} {input.reads} > {output.sam}"


rule sort_aln:
	input:
		sam = "mapped_reads/{sm}.unsorted.sam"
	output:
		bam = "mapped_reads/{sm}.bam"
	shell:
		"samtools view -Su -F 4 {input.sam} | samtools sort - > {output.bam} "


