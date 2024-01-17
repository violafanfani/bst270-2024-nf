# bst270-2024-nf

![](https://github.com/violafanfani/bst270-2024-nf/workflows/build/badge.svg)

bst270 nf project


## Configuration

- param1: this is the parameter description (default: "hello")
- ...
- paramN: this is the parameter description (default: "flow")

## Running the workflow

### Install or update the workflow

```bash
nextflow pull violafanfani/bst270-2024-nf
```

### Download MIDUS data
Midus data is protected, hence you'll need to download the data from this
[website](https://www.icpsr.umich.edu/web/NACDA/studies/4652/datadocumentation#).

Here we are using two files: `04652-0001-Data.rda` and `29282-0001-Data.rda`.
Once you have downloaded them, please change the path in the `conf/metadata.csv` file. 
Right now, the path is set to be the testdata folder.

### Run the analysis

```bash
nextflow run violafanfani/bst270-2024-nf
```

## Results

- `results/analysis.txt`: file with the analysis results.
- `results/tuning.txt`: file with the parameter tuning.
- ...

## Authors

- Viola Fanfani
