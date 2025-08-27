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
import statistics as stat

def render_markdown(text):
    md = markdownipy.markdownipy()
    md < text | md.h3
    display(Markdown(md.print()))


def basic_stats(x, y):
    avg = round(x.mean(),0)
    max_val = (x.max())
    min_val = (x.min())
    sd = round(stat.stdev(x), 2)
    
    render_markdown(y)
    print('Average number: ', avg)
    print('Maximum value: ', max_val)
    print('Minimum value: ', min_val)
    print('Standard deviation: ', sd)


def corr_info(x, y, z):
    corrval = x[[y, z]].corr().iloc[0,1]
    print(f"Correlation between these variables: {corrval:.2f}")
    if corrval == 0.0:
        print('This is a very weak correlation.')
    elif abs(corrval) <= 0.2:
        print('This is a very weak correlation.')
    elif abs(corrval) <= 0.39:
        print('This is a weak correlation.')
    elif abs(corrval) <= 0.59:
        print('This is a moderate correlation.')
    elif abs(corrval) <= 0.79:
        print('This is a strong correlation.')
    else:
        print('This is a very strong correlation.')
    

    















