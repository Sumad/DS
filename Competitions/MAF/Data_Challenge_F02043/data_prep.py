import numpy as np

# weekly Frequency functions 
def avg_wkly_visits(row, **kwargs):
    """Function to compute average weekly visits, from an anchor week and 
    going certain weeks back from anchor week"""
    anchor_week = kwargs['aw'] # 128
    look_back = kwargs['lb'] # 24
    total_wks = look_back
    total_wkly_cnt = 0
    for i in range(anchor_week - look_back + 1, anchor_week+1):
        total_wkly_cnt += np.sum(row == i)
    return(np.round(total_wkly_cnt/total_wks,3))    

def median_wkly_visits(row, **kwargs):
    """Function to compute average weekly visits, from an anchor week and 
    going certain week back from anchor week"""
    anchor_week = kwargs['aw'] 
    look_back = kwargs['lb'] 
    wkly_cnts = []
    for i in range(anchor_week - look_back + 1, anchor_week+1):
        wkly_cnts.append(np.sum(row == i))
        #print(wkly_cnts)
    #print(wkly_cnts)    
    return(np.median(wkly_cnts))

# Periodicity functions, weekly
def avg_time_wks_bw_visits(row, **kwargs):
    """Function to look back from anchor week, within window given by look_back,
    to compute time between visits.
    lag variable specifies lag to be considered.
    Eg: lag1 -> consecutive
         lag 2 -> igonore last visit"""
    anchor_week = kwargs['aw'] 
    look_back = kwargs['lb']
    lag = kwargs['lag']
    start_wk = anchor_week - look_back + 1
    end_wk = anchor_week
    #print(start_wk)
    #print(row)
    start_idx = np.min(np.where(row >= start_wk))
    end_idx = np.max(np.where(row <= end_wk))
    row_subset = row[start_idx : end_idx+1]
    time_diffs = []
    for i in range(len(row_subset)-lag):
        time_diffs.append(row_subset[i+lag] - row_subset[i])   
    return np.round(np.sum(time_diffs)/len(time_diffs),3)

def median_time_wks_bw_visits(row, **kwargs):
    """Function to look back from anchor week, within window given by look_back,
    to compute time between visits.
    lag variable specifies lag to be considered.
    Eg: lag1 -> consecutive
         lag 2 -> igonore last visit"""
    anchor_week = kwargs['aw'] 
    look_back = kwargs['lb']
    lag = kwargs['lag']
    start_wk = anchor_week - look_back + 1
    end_wk = anchor_week
    #print(start_wk)
    #print(row)
    start_idx = np.min(np.where(row >= start_wk))
    end_idx = np.max(np.where(row <= end_wk))
    row_subset = row[start_idx : end_idx+1]
    time_diffs = []
    for i in range(len(row_subset)-lag):
        time_diffs.append(row_subset[i+lag] - row_subset[i])    
    return np.median(time_diffs)

# Recency functions

def count_visits_last_x_week(row, **kwargs):
    """count of visits in last x week from anchor week, x can start from 0 meaning 
    anchor week"""
    anchor_week = kwargs['aw']
    week_ref = kwargs['xth_week']
    week = anchor_week - week_ref
    return np.sum(row == week)

def weeks_since_last_visit(row, **kwargs):
    """count weeks from anchor week to last visit"""
    anchor_week = kwargs['aw']
    last_visit = np.max(row[row <= anchor_week])
    diff = anchor_week - last_visit
    return diff

# weekly target
def create_target(row,**kwargs):
    """Create target variable based on kwarg - target_week"""
    if (kwargs['target_week'] in row):
        return 1
    else:
        return 0
    
"""
- Day preference (like day of week people visit?) 
  - avg. visits on each day of week for all visits from anchor week
  #- avg visits on each day in last x weeks (recent change in pattern)
- Peridic pattern (visit after x days) 
  - average time between visits in days with lags 
- recency
  - if you visited last xth week's m/t/w../s
  - days since last visit 
  #- count of days visited last week"""  

def avg_visits_by_wkday(row, **kwargs):
    """Function to compute average visits by day (1 to 7), from an anchor day and 
    going certain days back from anchor day"""
    anchor_day = kwargs['ad'] # 896
    #look_back = kwargs['lb'] # 896
    day = kwargs['day']
    #start_day = anchor_day - look_back + 1
    start_day = 1
    #end_day = anchor_day
    #print(start_wk)
    #print(row)
    #start_idx = np.min(np.where(row >= start_day))
    end_idx = np.max(np.where(row <= anchor_day))
    row_subset = row[0 : end_idx+1]
    row_subset_conv = row_subset % 7
    if(day ==7):
        return np.round(np.sum(row_subset_conv == 0)/anchor_day,3)
    else:
        return np.round(np.sum(row_subset_conv == day)/anchor_day,3)

def avg_days_bw_visits(row, **kwargs):    
    """Function to compute average time between visits, by weekday (1 to 7), from an anchor day and 
    going certain days back from anchor day.Also, by lag
    Eg: lag1 -> consecutive
         lag 2 -> igonore last visit"""
    anchor_day = kwargs['ad'] # 896
    #look_back = kwargs['lb'] # 896
    lag = kwargs['lag']
    day = kwargs['day']   
    #start_day = anchor_day - look_back + 1
    #end_day = anchor_day
    #print(start_wk)
    #print(row)
    #start_idx = np.min(np.where(row >= start_day))
    end_idx = np.max(np.where(row <= anchor_day))
    row_subset = row[0 : end_idx+1]
    row_subset_conv = row_subset % 7
    if(day!=7):
        idx = row_subset_conv == day
    else:
        idx = row_subset_conv == 0
    row_subset_2 = row_subset[idx]
    time_diffs = []
    for i in range(len(row_subset_2)-lag):
        time_diffs.append(row_subset_2[i+lag] - row_subset_2[i])   
    return np.round(np.sum(time_diffs)/len(time_diffs),3)

def ind_visit_last_x_wkday(row, **kwargs):
    """if visited last xth week's weekday from anchor week, x can start from 0 meaning 
    anchor day's week, anchor day will always be 7th day"""
    anchor_day = kwargs['ad'] # 896
    day = kwargs['day'] # 1
    week_ref = kwargs['xth_week'] # 1 means current week
    end_day = anchor_day - 7*week_ref
    start_day = end_day - 7 + 1
    try:
        start_idx = np.min(np.where(row >= start_day))
        end_idx = np.max(np.where(row <= end_day))
        row_subset = row[start_idx : end_idx+1]
        row_subset_conv = row_subset % 7
        if(day!=7):
            return int(np.any(row_subset_conv == day))
        else:
            return int(np.any(row_subset_conv == 0))
    except ValueError:
        return 0

def days_since_last_wday_visited(row, **kwargs):
    """count of days since the wkday given was visited from anchor day"""
    anchor_day = kwargs['ad'] # 98
    day = kwargs['day'] # 1
    try:
        end_idx = np.max(np.where(row <= anchor_day))
        row_subset = row[0 : end_idx+1]
        row_subset_conv = row_subset % 7
        if(day!=7):
            idx = row_subset_conv == day
        else:
            idx = row_subset_conv == 0
        #print(idx)    
        last_visit = np.max(row_subset[idx])
        diff = anchor_day - last_visit
        return diff  
    except ValueError:
        return -100

def create_mclass_target(row,**kwargs):
    tw = kwargs['target_week']
    label = -1
    for day in range(tw*7 - 7 +1, tw*7 +1):
        #print(type(row))
        if(day in row):
            if((day % 7) == 0):
                label = 7
                return label
            else:     
                label = (day%7)
                return label
    label = 0        
    return label
            
    