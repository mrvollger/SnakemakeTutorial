# Execute 

```
snakemake
```


# Dry run

``` 
snakemake -n 
```


# Run specifc rule
```
snakemake count_alns
```


# Make a report 

```
snakemake --report report.html
```


# Execute the snakemake on the cluster
```
snakemake --jobs 5 --cluster " qsub "
```


# Run a snakemake that is not called `Snakefile`
snakemake -s MultiSample.smk

