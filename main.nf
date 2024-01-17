// enabling nextflow DSL v2
nextflow.enable.dsl=2

// import from modules
include { plotGGPlot } from './modules/rsteps.nf'


process readMidus {

    publishDir "${params.resultsDir}/tables/", pattern: "*midus*", mode: 'copy'

    input:
        tuple val(name),file(data_optimism), file(data_biomarker)

    output:
        tuple val(name),file(data_optimism), file(data_biomarker), file('midus.csv'), file('read_midus.log')

    script:
    """
        Rscript ${baseDir}/bin/read_midus.r ${data_optimism} ${data_biomarker} midus.csv ${baseDir} > read_midus.log
    """

}

process plotFigure1 {

    publishDir "${params.resultsDir}/figures/", pattern: "fig1.pdf", mode: 'copy'

    input:
        tuple val(name),file(data_optimism), file(data_biomarker), file(midus), file(midus_log)

    output:
        tuple val(name),file(data_optimism), file(data_biomarker), file(midus), file(midus_log), file('fig1.pdf')

    script:
    """
        Rscript ${baseDir}/bin/plot_figure_1.R ${midus} fig1.pdf ${baseDir}
    """

}

process createTable2 {

    publishDir "${params.resultsDir}/tables/", pattern: "table2.csv", mode: 'copy'

    input:
        tuple val(name),file(data_optimism), file(data_biomarker), file(midus), file(midus_log)

    output:
        tuple val(name),file(data_optimism), file(data_biomarker), file(midus), file(midus_log), file('table2.csv')

    script:
    """
        Rscript ${baseDir}/bin/create_table2.R ${midus} table2.csv
    """
}

process plotFigureX {

    publishDir "${params.resultsDir}/figures/", pattern: "fig*.pdf", mode: 'copy'

    input:
        tuple val(data),file(data_optimism), file(data_biomarker), file(midus), file(midus_log), val(column)

    output:
        tuple val(data),file(data_optimism), file(data_biomarker), file(midus), file(midus_log), val(column), file("fig_${column}.pdf")

    script:
    """
        fit.py plot-column ${midus} fig_${column}.pdf -c ${column} 
    """

}


process plotFigureCorrelation {

    publishDir "${params.resultsDir}/figures/", pattern: "correlations*", mode: 'copy'

    input:
        tuple val(data),file(data_optimism), file(data_biomarker), file(midus), file(midus_log), file(table2), val(fig_format)

    output:
        tuple val(data),file(data_optimism), file(data_biomarker), file(midus), file(midus_log), file(table2), val(fig_format), file("correlations.${fig_format}")

    script:
    """
        fit.py plot-correlations ${table2} correlations.${fig_format}
    """

}


workflow {
    
    // define the output directory
    // params.resultsDir

    // define the input data
    data = Channel.fromPath(params.metadata) \
        | splitCsv(header:true) \
        | map { row-> tuple(row.name, file(row.biomarker_data), file(row.optimism_data)) } //| view()

    // Read midus data
    cleanData = readMidus(data)

    // Plot figure 1
    plotFigure1(cleanData)

    // Plot figure X
    newCh = cleanData.combine(Channel.from(params.columns)) //.view()
    plotFigureX(newCh)


    // Create table 2
    table2 = createTable2(cleanData)


    // plot figure from table 2
    plotFigureCorrelation(table2.combine(Channel.from(params.fig_format)))

    
}