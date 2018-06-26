# -*- coding: utf-8 -*-
"""
Spyder Editor

This is a temporary script file.
"""

import dash
import dash_core_components as dcc
import dash_html_components as html

'''Part 1: Visual components of the app are described using 
visual components in dcc and dtc'''

app = dash.Dash()

if __name__ == '__main__' :
    app.run_server(debug = True)