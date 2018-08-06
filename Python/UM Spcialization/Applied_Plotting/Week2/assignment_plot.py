# Imports
import matplotlib.pyplot as plt
import mplleaflet
import pandas as pd
import numpy as np 

# Read data
df = pd.read_csv('data/C2A2_data/BinnedCsvs_d400/fb441e62df2d58994928907a91895ec62c2c42e6cd075c2700843b89.csv')

# Subset data frames by 24 locationm and store in a dictionary
regions = [x for x in df['ID'].unique()]
dic = {}
for reg in regions:
    dic[reg] = df.loc[df['ID'] == reg,]

    
# Code to genrate plots in jupyter notebook interactively
%matplotlib notebook

fig, ax = plt.subplots(nrows= 8, ncols= 3, sharex= True, sharey= False, frameon = False, figsize = (10,10))
plt.subplots_adjust(wspace = 0.05)
coords = [(i,j) for i in range(8) for j in range(3)]
for coord, loc in zip(coords, dic.keys()):
    dic_dfs = process_frame(dic[loc])
    plot_base(dic_dfs['for_base'] ,coord, loc)
    plot_scatter(dic_dfs['for_scatter'], coord)
plt.suptitle("Record breaking temps. observed in 2015 \n compared to yearly minimum and maximum Temperatures "
             "in 2005-14,depicted by location", 
             size = 'small', weight = 'heavy')
    
    
# Functions used for plotting 

def process_frame(df):
    '''
    Function used to create data frames used for plotting line plots and scatter plots 
    
    Returns: 
    Two sets of data frames after performing following operations 
    - Creates a datetimeindex on the input frame
    - Removes leap year dates i.e 2/29
    - Selects records in time window [2005, 2014], and creates first set of frames
      - Creates a dataframe for least minimum temp. aggregared at yearly level,
        from daily minimum temperatures recorded 
      - Creates another dataframe for greatest maximum temp. aggregared at yearly level,
        from daily maximum temperatures recorded 
    - Find min and max temperatures from the above two frames. 
    - Create second set of frames 
      - Subset input frame for 2015, and for days when min temp dropped below record min from 05-14. 
      - Similar frame for when min temp went above record max from 05-14
    
    Arguments:
    1. df : An input pandas data frame  
    '''
    #df['Data_Value_new'] = round(df['Data_Value']/10,2)
    df.index = pd.to_datetime(df['Date'],errors= 'raise') 
    df['Month'] = df.index.month
    df['Day'] = df.index.day
    df_1= df.loc[~((df['Month'] == 2) & (df['Day'] == 29)),]
    
    df_05_14_min = df_1.loc[(df_1['Element'] == 'TMIN') & 
                    (df_1.index < pd.to_datetime('2015-01-01')) & 
                    (df_1.index >= pd.to_datetime('2005-01-01')),]
    df_05_14_max = df_1.loc[(df_1['Element'] == 'TMAX') & 
                    (df_1.index < pd.to_datetime('2015-01-01')) & 
                    (df_1.index >= pd.to_datetime('2005-01-01')),]
    
    df_05_14_yrly_lows = df_05_14_min.resample('A').agg({'Data_Value' : 'min'})
    df_05_14_yrly_highs = df_05_14_max.resample('A').agg({'Data_Value' : 'max'})
    
    mn = np.min(df_05_14_yrly_lows.values)
    mx = np.max(df_05_14_yrly_highs.values)
    
    df_15_daily_rcd_min = df_1.loc[(df_1['Element'] == 'TMIN') & 
                  (df_1.index >= pd.to_datetime('2015-01-01')) & 
                  (df_1['Data_Value'] < mn), 'Data_Value']
    df_15_daily_rcd_max = df_1.loc[(df_1['Element'] == 'TMAX') & 
                  (df_1.index >= pd.to_datetime('2015-01-01')) & (df_1['Data_Value'] > mx), 'Data_Value']
        
    dic_dfs = {'for_base' : {'yrly_lows' : df_05_14_yrly_lows,
                                'yrly_highs' : df_05_14_yrly_highs},
                  'for_scatter' : {'2015_rcd_low' : df_15_daily_rcd_min,
                                   '2015_rcd_high' : df_15_daily_rcd_max}}
    return(dic_dfs)  

def plot_base(dfs, coord, loc):
    '''
    Returns : 
     None, plots base line plots, title, x and y labels and legend for the plot. 
    Arguments : 
    1. dfs - Data frame used for plotting line charts
    2. coord - Coordinates used to identify a subplot and plot on it
    3. loc - Name of the location/ID given in the data
    '''
    df_lows = dfs['yrly_lows']
    df_highs = dfs['yrly_highs']
    
    # Set x limits to make space for legends of scatter plot 
    ax[coord[0], coord[1]].set_xlim([pd.Timestamp('12-31-2005'), pd.Timestamp('12-31-2017')])
    
    # Plot Lines for yearly lows and highs
    lines = ax[coord[0], coord[1]].plot(df_lows,'ro-',df_highs, 'bo-', markersize = 3)
    ax[coord[0], coord[1]].fill_between(x  = np.squeeze(df_lows.index.values), 
                                        y1 = np.squeeze(df_lows.values),
                                        y2 = np.squeeze(df_highs.values), 
                                        facecolor = 'green', alpha = 0.1)
    
    # Remove tick marks, except from y axis of left most plots, also remove y labels
    ax[coord[0], coord[1]].tick_params(left = False, labelleft = False)
    if(coord[0] == 7):
    #if(coord[0] == 4):    
        ax[coord[0], coord[1]].tick_params(bottom = True)
    else:
        ax[coord[0], coord[1]].tick_params(bottom = False)
        
    # Rotate tick labels on x axis and change font size    
    for lbl in ax[coord[0], coord[1]].get_xticklabels():
        lbl.set_rotation(45)
        lbl.set_size('x-small')
    
    # Plot lines, label the point with y values, as we have removed y axis ticks and ticklabels
    for pts in lines[0].get_xydata():
        ax[coord[0], coord[1]].text(pts[0], pts[1], str(pts[1]), fontsize = 5,
                                        va = 'bottom', ha = 'left', rotation = 45)
    for pts in lines[1].get_xydata():
        ax[coord[0], coord[1]].text(pts[0], pts[1], str(pts[1]), fontsize = 5,
                                        va = 'top', ha = 'left', rotation = 45)   
    # set title of a subplot as region name    
    ax[coord[0], coord[1]].set_title(loc, fontsize = 'xx-small', weight = 'heavy')  
    
    # Keep bottom spine only
    ax[coord[0], coord[1]].spines['right'].set_visible(False)
    ax[coord[0], coord[1]].spines['top'].set_visible(False)
    ax[coord[0], coord[1]].spines['left'].set_visible(False)
    
    
    
    # Add y and x labels to center subplots, to appear as plot y and x labels
    if((coord[0] == 7) & ((coord[1] == 1)) ):
        ax[coord[0], coord[1]].set_xlabel('Years')
    if((coord[0] == 3 ) & ((coord[1] == 0)) ): 
        ax[coord[0], coord[1]].set_ylabel(' Temperature in tenth degree C')
    
    # Fig legend , draw at last iteration, use the lines drawn to create this one
    if((coord[0] == 4 ) & ((coord[1] == 1)) ):
        fig.legend(handles = [lines[0], lines[1]], labels = ['Min Temps.', 'Max. Temps.'],loc = 'best')
        
def plot_scatter(dfs, coord):
    '''
    Function used to plot the record breaking temperatures in 2015 as a scatter plot, and identify the days using a legend
    
    Returns : 
     None, plots scatter plot,and legend for the subplots. 
    Arguments : 
    1. dfs - Data frame used for plotting scatter plots
    2. coord - Coordinates used to identify a subplot and plot on it
    '''
    df_lows = dfs['2015_rcd_low'].sort_values(ascending = True)
    df_highs = dfs['2015_rcd_high'].sort_values(ascending = True)
    
    legend_dic = {"frameon" : False ,
                  "loc" : 'center right',
                  "fontsize" : 5,
                  'title' : 'Record 2015 \n Temp. days'}
    marker_cols = ['purple', 'green', 'orange','black']               
    for i,dt in enumerate(df_lows.index):
        month_day = str(dt.month) + '/' + str(dt.day)
        # use ax.scatter to plot, so markers can come on legend
        ax[coord[0], coord[1]].scatter(dt, df_lows.loc[dt,], 
                                    marker = '*', c = marker_cols[i], s = 4, label = month_day)
        leg = ax[coord[0], coord[1]].legend(**legend_dic)
        # A quirk to change the fontsize of legend title 
        leg.get_title().set_fontsize(4)
    
                         
    for i,dt in enumerate(df_highs.index):
        month_day = str(dt.month) + '/' + str(dt.day)
        ax[coord[0], coord[1]].scatter(dt, df_lows.loc[dt,], 
                                    marker = '*', c = marker_cols[i], s = 4, label = month_day)
        leg = ax[coord[0], coord[1]].legend(**legend_dic)
        # A quirk to change the fontsize of legend title 
        leg.get_title().set_fontsize(5)    
        