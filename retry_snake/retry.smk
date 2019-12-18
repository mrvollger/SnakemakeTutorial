import os
import sys


infiles = { os.path.basename(x.strip()) :  x.strip() for x in open("input.fofn") }
samples = list(infiles.keys())



rule all:
	input:
		txt = expand("output/{SM}.out", SM=samples)


# you can use functions to define input files
def get_input_from_wc(wildcards):
	# get the wildcard for samples
	SM = str(wildcards.SM)
	# return associated file
	return(infiles[SM])	

rule retryrule:
	input: 
		txt = get_input_from_wc,
	output:
		txt  = "output/{SM}.out"
	params:
		cluster_flags = " -pe serial 1 "
	shell:"""
wc -l {input.txt} > {output.txt}
"""

