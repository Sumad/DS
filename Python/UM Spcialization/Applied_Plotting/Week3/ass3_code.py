# Use the following data for this assignment:

df = pd.DataFrame([np.random.normal(32000,200000,3650), 
                   np.random.normal(43000,100000,3650), 
                   np.random.normal(43500,140000,3650), 
                   np.random.normal(48000,70000,3650)], 
                  index=[1992,1993,1994,1995])


summary = df.T.describe()
means = summary.loc['mean',:]
pop_sd = [200000, 100000, 140000, 70000]
sampling_sd = [el/np.sqrt(3650) for el in pop_sd]

def draw_bar(df = df, means = means, sd = sampling_sd, y = 0.0):
    ubs = stats.norm.ppf(q= 0.975, loc = means, scale = sd)
    lbs = stats.norm.ppf(q= 0.025, loc = means, scale = sd)
    err= [x-y for x,y in zip(ubs,lbs)]
    labels = [str(x) for x in df.index.values]
    left = [x for x in df.index.values]
    ax = plt.gcf().get_axes()[0]
    ax.spines['right'].set_visible(False)
    ax.spines['top'].set_visible(False)
    pt = ax.bar(left = left, height = means, yerr = err, capsize = 10,
               tick_label = labels)
    plt.suptitle("Probability of chosen y axis value {:.2f} \n \
    to be representative of population of samples".format(y))
    return(pt)

def get_probs(x, means = means, sd = sampling_sd):
    """Function to compute one side probability from each of the sample means,
    then return double sides probability
    """
    probs = []
    for mean,sd in zip(means, sd):
        #print(mean,sd)
        if(x>=mean):
            prob = stats.norm.cdf(x, loc = mean, scale = sd) - 0.5
        else:
            prob = 0.5 - stats.norm.cdf(x, loc = mean, scale = sd)
        probs.append(1 - 2*prob)
        print(probs)
    return probs    

def set_clrs(probs, bar_container):
    """Function to change color of bars using probability values, 
    probability values can be mapped to a sequential colormap in matplotlib
    """
    import matplotlib
    probs_round = [np.round(x,2) for x in probs]
    cmap = plt.get_cmap('jet')
    norm = mpl.colors.Normalize(vmin= 0,vmax= 1)
    mapping = plt.cm.ScalarMappable(cmap= cmap, norm= norm)
    mapping.set_array([])
    objs = bar_container.patches
    for i,obj in enumerate(objs):
        if(isinstance(obj, matplotlib.patches.Rectangle)):
            obj.set_color(mapping.to_rgba(probs_round[i]))
        else:
            print('Check if object is of types patches.Recatangle')       
    plt.colorbar(mappable = mapping, cax = plt.gcf().get_axes()[1])

def on_click(event):
    """Function to take a button presss event data, draw a horizontal line at y coordinate, and
    subsequently call function get_probs"""
    # Record y values and x limits, clear figure
    y = event.ydata
    plt.gcf().get_axes()[0].cla()
    container = draw_bar(y = y)
    x_limits = plt.gcf().get_axes()[0].get_xlim()
    probs = get_probs(x = y)
    x = set_clrs(probs = probs, bar_container = container)
    main_ax = plt.gcf().get_axes()[0]
    main_ax.hlines(y = y,xmin = x_limits[0], xmax = x_limits[1],
                                  linestyles = 'dashed', colors = 'grey')

from matplotlib import gridspec as gs
plt.figure()
gspec = gs.GridSpec(nrows= 1, ncols = 6)
_ = plt.subplot(gspec[0,0:5])
_ = plt.subplot(gspec[0,5])
plt.subplots_adjust(wspace = 1)

draw_bar(df, means, sampling_sd)
plt.gcf().canvas.mpl_connect('button_press_event', on_click) 
np.random.seed(12345)

