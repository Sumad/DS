import pandas as pd
import numpy as np
import requests
from bs4 import BeautifulSoup as bs

##### Extract all file urls from the source page into 3 categories

root = 'https://www1.ncdc.noaa.gov/pub/data/swdi/stormevents/csvfiles/'
response = requests.get(root)

soup = bs(response.content, 'html.parser')

links = []
tags = soup.findAll(name = 'a')
for tag in tags:
    text = tag.get_text()
    if(text.startswith('StormEvents')):
        links.append(text)

fat_links = [link for link in links if 'fatalities' in link]
loc_links = [link for link in links if 'locations' in link]
details = [link for link in links if 'details' in link]

print(len(fat_links))
print(len(loc_links))
print(len(details))

#fat_links
#loc_links
#details

##### Iteratively read files of all three categories 

event_cols = ['EPISODE_ID', 'EVENT_ID', 'STATE', 
              'STATE_FIPS', 'EVENT_TYPE', 'CZ_TYPE', 'CZ_FIPS', 'CZ_NAME',
             "BEGIN_YEARMONTH",'BEGIN_DATE_TIME', 'CZ_TIMEZONE', 'END_DATE_TIME',
             "INJURIES_DIRECT", "INJURIES_INDIRECT", "DEATHS_DIRECT", 
              "DEATHS_INDIRECT", "DAMAGE_PROPERTY", "DAMAGE_CROPS", "SOURCE",
             'CATEGORY', ]
#fat_cols = ["FATALITY_ID", "EVENT_ID", "FATALITY_TYPE", "FATALITY_DATE", 
#            "FATALITY_AGE", "FATALITY_SEX", "FATALITY_LOCATION"]

Read event file
- filter on EVENT_TYPE as Hurricane 
- group by BEGIN_YEARMONTH, State_FIPS, CZ_FIPS,category,aggregate damages 

def func(x):
    #print(x)
    try:
        if(np.isnan(x)):
            return np.nan
    except TypeError:
        #print(x)
        x = str(x)
        if((x[-1] == 'M') & (len(x)>1)):
            return (float(x[0:-1])*1000000)
        elif((x[-1] == 'M') & (len(x)==1)):
            return(1000000)
        elif((x[-1] == 'K') & (len(x)>1)):
            return(float(x[0:-1])*1000)
        elif((x[-1] == 'K') & (len(x)==1)):
            return(1000)
        elif(len(x) == 1):
            return(float(x))
        else:
            return(float(x[0:-1]))
detail_sub = details
grp_key = [ 'STATE_FIPS', 'CZ_FIPS','CZ_TYPE', 'BEGIN_YEARMONTH', ]
agg_cols = ["DAMAGE_PROPERTY_der"]
agg_dic = {col : 'max' for col in agg_cols}
ind = 0
for i,link in enumerate(detail_sub):
    dt = pd.read_csv(root+link)
    dt_ = dt.loc[(dt['EVENT_TYPE']== 'Tornado'), :].copy()
    if(len(dt_)==0):
        continue
    for col in ["DAMAGE_PROPERTY", ]:
        dt_[col+'_der'] = dt_.loc[:,col].map(func)
    dt_1 = dt_.groupby(grp_key).agg(agg_dic)
    print(len(dt_1))
    if(ind==0):
        dt_all = dt_1
        ind += 1
    else:
        dt_all = pd.concat([dt_all, dt_1])

dt_all.shape

dt_all_2 = dt_all.reset_index(inplace= False)

dt_all_3 = dt_all_2.loc[dt_all_2['CZ_TYPE'] == 'C',:]

dt_all_3.shape

dt_all_3.head()

(dt_all_3.groupby(['CZ_FIPS', 'BEGIN_YEARMONTH']).agg({'STATE_FIPS': 'count'})
.sort_values(by = 'STATE_FIPS', ascending = False).head())

#### Plot on map of states with FIPS values 12,13,22,48 ; destruction of property


def sz(x):
    x = str(int(x))
    if(len(x)==1):
        x = '0'+ x
        return(x)
    else:
        return(x)
    
def cz(x):
    x = str(int(x))
    if(len(x)==1):
        x = '00'+ x
        return(x)
    elif(len(x)==2):
        x = '0'+ x
        return(x)
    else:
        return(x)
        
dt_all_3['STATE_FIPS'+'_der'] = dt_all_3.loc[:,'STATE_FIPS'].copy().map(sz)
dt_all_3['CZ_FIPS' + '_der'] = dt_all_3.loc[:,'CZ_FIPS'].copy().map(cz)
dt_all_3['FIPS_der'] = dt_all_3.loc[:,'STATE_FIPS_der'].copy() + dt_all_3.loc[:,'CZ_FIPS_der'].copy()

#### Create a column with 5 year windows from 1950 to 2017
yr_map = {}
yrs = np.arange(1950,2015,1)
ind = list(range(5)) * (int(len(yrs)/5))

for i,yr in zip(ind, yrs):
    val = str(yr-i) + '-' + str(yr + 4 -i)[-2:]
    yr_map[str(yr)] = val

def create_yr_range(x):
    if(int(str(x)[0:4]) <= 2014):
        return(yr_map[str(x)[0:4]])
    else:
        return '0'
    
dt_all_3['Yr_range'] = dt_all_3.loc[:,"BEGIN_YEARMONTH"].copy().map(lambda x : create_yr_range(x))    

dt_all_4 = dt_all_3.loc[~(dt_all_3['Yr_range'] == '0'),:]

dt_all_4.tail()

df = dt_all_4.groupby(["FIPS_der", "Yr_range"]).agg({'CZ_FIPS_der': 'count',
                                               'DAMAGE_PROPERTY_der': 'sum'})

df.shape

df.head()

by_cnty = df.groupby(by = 'FIPS_der').sum()

by_cnty.shape

by_cnty.head()

by_cnty.describe()

sum(np.isnan(by_cnty['DAMAGE_PROPERTY_der']))

by_cnty_2 = by_cnty.loc[~np.isnan(by_cnty['DAMAGE_PROPERTY_der']),:]

%matplotlib inline
from matplotlib import pyplot as plt

from matplotlib import gridspec
import plotly
import plotly.figure_factory as ff
from plotly.offline import  init_notebook_mode, plot, iplot
import plotly.graph_objs as go
import plotly.io as pio

def plt_scatter(df):
    """Plot a scatter of fips values, each represented by total hurricanes experienced 
    in 1950-2014 period on x axis, and total property damage in USD on y axis.
    - Color the fips values over 0.4 Bilion USD, and draw a line
    - Color the fips values greater than 75 hurriacanes, and draw a vertical line 
    - Place a text as region 1 / region 2
    Draw boxplots on both axes
    """
    orgs = df.loc[df['CZ_FIPS_der'] > 75, :].copy()
    reds = df.loc[df['DAMAGE_PROPERTY_der'] > 400000000. , :].copy()
    
    fig = plt.figure(figsize=(12,6))
    gs = gridspec.GridSpec(3,3)
    sc_plt = plt.subplot(gs[1:,1:])
    y_box = plt.subplot(gs[1:,0])
    x_box = plt.subplot(gs[0,1:])
    
    _ = x_box.boxplot(df['CZ_FIPS_der'], vert = False)
    for sp in x_box.spines.values():
        sp.set_visible(False)
   
    x_box.tick_params(bottom = 'off', 
                      top = 'off',
                      left = 'off', 
                      right = 'off',
                     labelbottom = 'off', 
                      labeltop = 'off', 
                      labelleft = 'off', 
                      labelright = 'off')    
    _ = y_box.boxplot(df['DAMAGE_PROPERTY_der'], vert = True)
   
    for sp in y_box.spines.values():
        sp.set_visible(False)
    y_box.tick_params(bottom = 'off', 
                      top = 'off',
                      left = 'off', 
                      right = 'off',
                     labelbottom = 'off', 
                      labeltop = 'off', 
                      labelleft = 'off', 
                      labelright = 'off')   
    _ = sc_plt.scatter(x = df['CZ_FIPS_der'], y = df['DAMAGE_PROPERTY_der'],
                      marker = '.', c = 'teal',alpha = 0.7, s = 20, label = 'Other')
    _ = sc_plt.scatter(x = reds['CZ_FIPS_der'], y = reds['DAMAGE_PROPERTY_der'],
                      marker = '.', c = 'red', alpha = 0.7, s =30, label = 'Higher Severity')
    _ = sc_plt.scatter(x = orgs['CZ_FIPS_der'], y = orgs['DAMAGE_PROPERTY_der'],
                      marker = '.', c = 'orange',alpha = 0.7, s =30, label = 'Higher Frequency')
    sc_plt.ticklabel_format(axis = 'y', style = 'sci')
    y_box.ticklabel_format(axis = 'y', style = 'plain')
    x_box.set_title('US counties by number of hurricanes \n and property damage in the period 1950-2014')
    sc_plt.set_xlabel('Number of hurricanes')
    y_box.set_ylabel('Property Damage in USD Billion')
    sc_plt.spines['right'].set_visible(False)
    sc_plt.spines['top'].set_visible(False)
    sc_plt.legend(loc = 'best', fontsize = 'xx-small')
    plt.subplots_adjust(wspace = 0.21, hspace = 0.2)    
    return(fig)
    
    
def plt_map(df):
    """Plot a US map, and show the selected region 1 and 2 counties on the map
    """
    #cmap = plt.get_cmap('RdBu')
    init_notebook_mode(connected=True)
    fips = list(df.index.values)
    values = list(df['Category'])
    fig = go.Figure()
    fig = ff.create_choropleth(fips = fips, values = values, 
                               scope = ['usa'], colorscale = ['orange','red', 'teal'],
                              title = 'Geographical location of counties',
                               legend_title = 'County Cateogorization',
                               county_outline={'color': 'rgb(255,255,255)', 'width': 0.5}
                              )
    #plotly.offline.iplot(fig)
    iplot(fig)
    #img_bytes = pio.to_image(fig, format='png')
    return(fig)
    

by_cnty_2['Category'] = 'Other'
by_cnty_2.loc[(by_cnty_2['CZ_FIPS_der'] > 75), 'Category'] = 'Higher Frequency'
by_cnty_2.loc[by_cnty_2['DAMAGE_PROPERTY_der'] > 400000000., 'Category'] = 'Higher Severity'
odd_cnties = ['02155', '06000', '12000','13597','15000','16000','29677','30000', '32000','37000',
 '46000','46001','46131','51039','51123','51780','53000', '99003','99005',
 '99008','99009', '99010','99021','99081','99099','99127']
mask = by_cnty_2.index.map(lambda x : x not in odd_cnties)
by_cnty_3 = by_cnty_2.loc[mask.values,:]

%matplotlib inline

fig = plt_scatter(by_cnty_3)

fig.savefig('plot1',format = 'png', transparent = True, facecolor = 'w', edgecolor = 'w')

fig2 = plt_map(by_cnty_3)