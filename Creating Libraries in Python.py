# Creating custom library

# Import libraries
import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
import seaborn as sns
import IPython
from IPython.display import display
from markdownipy import markdownipy
from IPython.display import Markdown

md_top5 = markdownipy.markdownipy()
md_bottom5 = markdownipy.markdownipy()
md_info = markdownipy.markdownipy()
md_dupes = markdownipy.markdownipy()
md_stats = markdownipy.markdownipy()
md_miss = markdownipy.markdownipy()
md_unique = markdownipy.markdownipy()
md_stats =markdownipy.markdownipy()
md_chart = markdownipy.markdownipy()


def data_check(x):
    md_top5 = markdownipy.markdownipy()
    md_top5 < "Top 5" | md_top5.h3 
    Markdown(md_top5.print())
    display(x.head()) # Top 5 rows
    
    md_bottom5 = markdownipy.markdownipy()
    md_bottom5 < "Bottom 5" | md_bottom5.h3 
    Markdown(md_bottom5.print())
    display(x.tail()) #Bottom 5 rows

    md_info = markdownipy.markdownipy()
    md_info < "Dataframe Information" | md_info.h3 
    Markdown(md_info.print())
    display(x.info()) # Information

    md_dupes = markdownipy.markdownipy()
    md_dupes < "Duplicate Count" | md_dupes.h3 
    Markdown(md_dupes.print())
    display(x.duplicated().sum()) # Duplicate count

    md_miss = markdownipy.markdownipy()
    md_miss < "Missing Values Count" | md_miss.h3 
    Markdown(md_miss.print())
    display(x.isna().sum()) # N/A count

    md_unique = markdownipy.markdownipy()
    md_unique < "Unique Values Count" | md_unique.h3 
    Markdown(md_unique.print())
    display(x.nunique()) # count unique values by columns

    md_stats = markdownipy.markdownipy()
    md_stats < "Descriptive Stats" | md_stats.h3 
    Markdown(md_stats.print())
    display(x.describe()) # Descriptive stats
    
    #chart = x.nunique() # Show chart
    #chart = pd.DataFrame(chart).reset_index()
    #chart = chart.head(10)
    #display(chart)
    #plt.figure(figsize = (18,6))
    #sns.barplot(data = top_10, x = 'index', y = 'index')
    #plt.show















