import matplotlib.pyplot as plt
import mplleaflet
import pandas as pd
import numpy as np 

df = pd.read_csv('data/C2A2_data/BinnedCsvs_d400/fb441e62df2d58994928907a91895ec62c2c42e6cd075c2700843b89.csv')

dfs = process_frame(df)
dfs_1 = dfs['for_base']
dfs_2 = dfs['for_scatter']

%matplotlib notebook 
fig = plt.figure()
fig.set_size_inches((9,6))
line_1 = plt.plot(dfs_1['lows_05_14'], c = 'black', linestyle = '-', 
                  linewidth = 0.8,alpha = 0.3, label = 'Daily Min(2005-14)')
line_2 = plt.plot(dfs_1['highs_05_14'],c = 'green', linestyle = '-',
                  linewidth = 0.8, alpha = 0.3, label = 'Daily Max(2005-14)')
plt.fill_between(x  = range(1,366), y1 = np.squeeze(dfs_1['lows_05_14'].values),
                                        y2 = np.squeeze(dfs_1['highs_05_14'].values), 
                                        facecolor = 'yellow', alpha = 0.1)
dots_1 = plt.plot(dfs_2['lows_15'], 'bo', markersize = 2, label = 'Record Breaking Daily Min(2015)')
dots_2 = plt.plot(dfs_2['highs_15'], 'ro', markersize = 2, label = 'Record Breaking Daily Max(2015)')
plt.title("Record breaking temperatures observed at Ann Arbor in 2015 \n"
         "compared to last 10 years", weight = 'heavy', fontsize = 'medium')
plt.legend( loc = 'lower right' , fontsize = 'x-small')
plt.xlabel('Days of Year (1-365)', fontsize = 'small', weight = 'heavy')
plt.ylabel(' Temperature in Degrees Celsius', fontsize = 'small', weight = 'heavy')

# Remove extra spine
ax = plt.gca()
ax.spines['right'].set_visible(False)
ax.spines['top'].set_visible(False)

# Change y tick tables to show in Degree celsius
ax.set_yticklabels([ t/10 for t in ax.get_yticks()]) # get_yticks() gets labels in an array
                                                     # but need to use set_yticklabels to set labels,
                                                     # set_ticks inserts ticks
ax.set_xticks(ticks = range(0,366), minor = True)        


def process_frame(df):
    '''
    Function used to create data frames used for plotting line plots and scatter plots
    '''
    df.index = pd.to_datetime(df['Date'],errors= 'raise') 
    df['Year'] = df.index.year
    df['Month'] = df.index.month
    df['DayYear'] = df.index.dayofyear
    df['DayMonth'] = df.index.day
    df_1= df.loc[~((df['Month'] == 2) & (df['DayMonth'] == 29)),]
    df_1_alt = df_1.copy()
    df_1_alt['DayYear'] = df_1_alt['DayYear'] - 1
    
    # use of where to do if else
    df_2 = df_1.where((df_1['Year'] % 4 != 0) | (df_1['Month'] <= 2), df_1_alt)
    
    # Find per day min and max temps in 05-14
    df_05_14_min = df_2.loc[(df_2['Element'] == 'TMIN') & 
                    (df_2.index < pd.to_datetime('2015-01-01')) & 
                    (df_2.index >= pd.to_datetime('2005-01-01')),]
    df_05_14_max = df_2.loc[(df_2['Element'] == 'TMAX') & 
                    (df_2.index < pd.to_datetime('2015-01-01')) & 
                    (df_2.index >= pd.to_datetime('2005-01-01')),]
    df_05_14_min_hist = df_05_14_min.groupby('DayYear').agg({'Data_Value': np.min})
    df_05_14_max_hist = df_05_14_max.groupby('DayYear').agg({'Data_Value':np.max})
    
    # Filter 2015 min and max temps, and get min max by day
    df_15_min = (df_2.loc[(df_2['Element'] == 'TMIN') & 
                         (df_2.index >= pd.to_datetime('2015-01-01')),]
                    .groupby('DayYear').agg({'Data_Value': np.min}))
    df_15_max = (df_2.loc[(df_2['Element'] == 'TMAX') & 
                         (df_2.index >= pd.to_datetime('2015-01-01')),]
                    .groupby('DayYear').agg({'Data_Value': np.max}))
    
    df_15_min_1 = pd.merge(df_15_min, df_05_14_min_hist, how = 'left',
                           left_index = True,right_index = True)
    df_15_min_2 = (df_15_min_1.where(df_15_min_1['Data_Value_x'] - df_15_min_1['Data_Value_y'] < 0)
                             .dropna()['Data_Value_x'])
                     
    df_15_max_1 = pd.merge(df_15_max, df_05_14_max_hist, how = 'left',
                           left_index = True, right_index = True)
    df_15_max_2 = (df_15_max_1.where(df_15_max_1['Data_Value_x'] - df_15_max_1['Data_Value_y'] > 0)
                             .dropna()['Data_Value_x'])
   
    
    
    dic_dfs = {'for_base' : {'lows_05_14' : df_05_14_min_hist,
                                'highs_05_14' : df_05_14_max_hist},
              'for_scatter' : {'lows_15' : df_15_min_2,
                                   'highs_15' : df_15_max_2}}
    return(dic_dfs)