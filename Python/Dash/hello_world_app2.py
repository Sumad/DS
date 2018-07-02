#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Sat Jun 30 23:39:36 2018

@author: sumad
"""

'''Use of html components ,attributes and properties - 
Modify the hello_world_app by adding style attributes to Div (it is a global attr.
) and properties color and text-align, text-align in Dash is textAlign.
Also, Change background color of graph and text color using keyword arguments 
in dcc.Graph component'''

import dash
import dash_core_components as dcc
import dash_html_components as html

'''Part 1: Visual components of the app are described using 
classes available in dcc and html modules'''

app = dash.Dash() # Create an object calling Dash() method and call method 
                  # run_server() later

colors =  {'background' : 'lightgrey', 'text' : 'black' } 
                 
app.layout = html.Div(style = {'backgroundColor' : colors['background'],},
                      children = 
                      [html.H1(children = "Dash: A Dash App", 
                               style = {'textAlign': 'center',
                                              'color' : colors['text']}),
       html.Div(children = "Chart"),
       dcc.Graph(
               id = 'Graph Chart',
               figure = {
               'data' : [{'x' : [1,2,3], 'y': [4,2,5], 'type' : 'bar', 'name' : 'SF'},
                         {'x' : [1,2,3], 'y': [2,3,6], 'type' : 'bar', 'name' : 'Montreal'},
                                  ],
               'layout' : {'title': 'Dash Data Visualization',
                           'plot_bgcolor' : colors['background'],
                           'font' : {'color' : colors['text'],
                                   }}
               })
        ]
        )
                  
if __name__ == "__main__" :
    app.run_server(debug = True)
    
                  