SNAKEMAKE_DIR = os.path.dirname(workflow.snakefile) + "/"
shell.executable("/bin/bash")
shell.prefix("source %s/env.cfg; set -eo pipefail; " % SNAKEMAKE_DIR)



infiles = [line.strip() for line in open("test.csv").readlines()]
IDS = list(range(len(infiles)))


def get_input(wildcards):
	ID = int(str(wildcards.ID))
	return(infiles[ID])

rule all:
	input:
		merge="concat.txt",

rule make_b:
	input:
	output: 
		b= "b.txt",
	run:
		open(output["b"], "w+").write("test")

rule make_a:
	input:
		b= "b.txt",
	output:
		test = "a.txt",
	shell:"""
touch {output.test}
"""

rule raw_mz:
	input:
		raw=get_input,
	output:
		mz="inter.{ID}.mzml",
	shell:"""
touch {output.mz}
"""

rule mz_pep:
	input:
		mz="inter.{ID}.mzml",
	output:
		pep="inter.{ID}.mzml.pep",
	shell:"""
touch {output.pep}
"""
	
rule merge_mz:
	input:
		mzs = expand("inter.{ID}.mzml.pep", ID=IDS),
	output:
		merge="concat.txt",
	shell:"""
cat {input.mzs} > {output.merge}
"""

