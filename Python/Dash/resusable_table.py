#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Sun Jul  1 17:02:55 2018

@author: sumad
"""

''' App utilizing a resusable component - html table to see
first 10 rows of a data'''

import dash
import dash_core_components as dcc
import dash_html_components as html
import pandas as pd

filepath = "/Users/sumad/Documents/DS/Competitions/Cat_claims/Raw_Data/"
df = pd.read_csv(filepath + "Training_set_v2.csv")

def genrate_tbl(df, n_rows):
    '''
    Reusable function to see rows of data in the app
    '''
    
    

app = dash.Dash()

if __name__ == "__main__":
    app.run_server(debug = True)