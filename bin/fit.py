#!/usr/bin/env python

import click
import pandas as pd
import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns
from matplotlib.patches import Rectangle
from matplotlib.colors import to_rgba as to_rgba


@click.group()
def cli():
    pass



@click.command()
@click.argument('input_table')
@click.argument('output_figure')
@click.option("-c", "--column", help="Column to plot")
def plot_column(input_table:str,output_figure:str, column: str):
    print("fitting a linear model from: ", input_table)
    
    with open(input_table, 'r') as f:
        df = pd.read_csv(input_table)
    print(df)
    
    f,ax = plt.subplots(1)
    sns.histplot(x = column, data = df, ax = ax)
    f.savefig(output_figure)


@click.command()
@click.argument('input_table')
@click.argument('output_figure')
def plot_correlations(input_table:str,output_figure:str):
    print("fitting a linear model from: ", input_table)
    
    with open(input_table, 'r') as f:
        df = pd.read_csv(input_table)
        
    df['pfloat'] = [float(x[1:]) if x.startswith('<') else float(x) for x in df['p']]
    df['is_significant'] = df['pfloat'] < 0.05
    
    df = df.sort_values(by='r', ascending=False)
    f,ax0 = plt.subplots(1)
    # Diverging palette
    sns.barplot(y='Characteristic', x='r',data = df, palette="vlag_r", ax=ax0)
    ax0.axvline(0, color="k", clip_on=False)


    bars = [r for r in ax0.get_children() if type(r)==Rectangle]
    colors = [c.get_facecolor() for c in bars[:-1]] # I think the last Rectangle is the background.
    cs = [x  if df['is_significant'][i] else to_rgba('grey') for i,x in enumerate(colors)]
    
    f,ax = plt.subplots(1)
    sns.barplot(y='Characteristic', x='r',data = df, palette = cs, ax=ax)
    ax.axvline(0, color="k", clip_on=False)
    ax.set_xlabel("Correlation coefficient\n grey: p >= 0.05")
    f.savefig(output_figure, bbox_inches='tight')

cli.add_command(plot_column)
cli.add_command(plot_correlations)

if __name__ == '__main__':
    cli()
