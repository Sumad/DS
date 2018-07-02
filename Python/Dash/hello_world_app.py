# -*- coding: utf-8 -*-
"""
Spyder Editor

This is a temporary script file.
"""

import dash
import dash_core_components as dcc
import dash_html_components as html

'''Part 1: Visual components of the app are described using 
classes available in dcc and html modules'''

app = dash.Dash() # Create an object calling Dash() method and call method 
                  # run_server() later
                  
# Layout of app. is described using components - 
#  html_components lib has html components for all html tags
# interactive components availble in core_components

# All components are declarative and arguments/properties are specified as 
# key: value pairs
                  
# HTML terminology
## elements , desrcibed by tags eg: 
### <h1> This is a header </h1>
## attributes and values: Elements can have attributes, specified in the
## starting tag eg: <h1 style = "background-colur : blue"> This is a header </h1>
## Global Attributes
## Event Attributes                    
                  
# Div element creates a section on html page 
                  # children argument is an argument available to specify 
                  # sub tags (in html language)
app.layout = html.Div(children = [
        html.H1("Dash : A Python Framework for Web App."),
        html.Div(children = "Chart"),
        dcc.Graph(id = 'Bar plot', 
                  figure = {  # described using dictionary with keys data - list of dics, layout - dictionary
                          'data' : [  # list of dictionaries
                                  {'x' : [1,2,3], 'y': [4,2,5], 'type' : 'bar', 'name' : 'SF'},
                                  {'x' : [1,2,3], 'y': [2,3,6], 'type' : 'bar', 'name' : 'Montreal'},
                                  ],
                          'layout': {
                'title': 'Dash Data Visualization'
                }
                }
                )
           ])

if __name__ == '__main__' :
    app.run_server(debug = True)