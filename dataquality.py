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

def render_markdown(text):
    md = markdownipy.markdownipy()
    md < text | md.h3
    display(Markdown(md.print()))


def data_check(x):
    render_markdown("Row & Col Count")
    display(x.shape) # Row & col count
    
    render_markdown("Top 5 Rows")
    display(x.head()) # Top 5 rows
    
    render_markdown("Bottom 5 Rows")
    display(x.tail()) #Bottom 5 rows

    render_markdown("Data Information")
    display(x.info()) # Information

    render_markdown("Duplicate count")
    display(x.duplicated().sum()) # Duplicate count

    render_markdown("Missing Values Count")
    display(x.isna().sum()) # N/A count

    render_markdown("Unique Values Count")
    display(x.nunique()) # count unique values by columns

    render_markdown("Descriptive Stats")
    display(x.describe()) # Descriptive stats
    
    #chart = x.nunique() # Show chart
    #chart = pd.DataFrame(chart).reset_index()
    #chart = chart.head(10)
    #display(chart)
    #plt.figure(figsize = (18,6))
    #sns.barplot(data = top_10, x = 'index', y = 'index')
    #plt.show















