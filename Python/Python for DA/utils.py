def score(probs , cut_off):
    '''
    Function to return a score using a list of probabilities and a cut off probability
    ---
    probs =  list of probabilities
    cut_off =  a single cut off probability
    '''
    score_list = []
    for prob in probs:
        if prob > cut_off:
            score_list.append(1)
        else:
            score_list.append(0)
    return score_list        