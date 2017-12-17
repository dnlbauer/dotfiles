#!/usr/bin/env python

import tkFileDialog
import tkSimpleDialog
from pymol import cmd
import math

DEFAULT_CUTOFF = 10
DEFAULT_FLOOR = 0.6
DEFAULT_MAX_CONTACTS = -1

def __init__(self):
    self.menuBar.addmenuitem('Plugin', 'command', 'MSA Scores', label='MSA Scores', command=lambda s=self: load_scores_dialog(s))

def load_scores_dialog(app):
    scores_file = tkFileDialog.askopenfile(initialdir=".", title="Load scores")
    if scores_file is None:
        return
    cutoff = tkSimpleDialog.askinteger("Cutoff", "Backbone cutoff", initialvalue=DEFAULT_CUTOFF, minvalue=1)
    if cutoff is None:
        return
    floor = tkSimpleDialog.askfloat("Minimal Score", "Minimal Score", initialvalue=DEFAULT_FLOOR)
    if floor is None:
        return
    max_contacts = tkSimpleDialog.askfloat("Limit contacts", "Maximal contacts to show", initialvalue=DEFAULT_MAX_CONTACTS)
    if max_contacts is None:
        return
    show_scores(scores=scores_file, cutoff=cutoff, floor=floor, max_contacts=max_contacts)

def show_scores(selection='all', scores="scores.csv", floor=DEFAULT_FLOOR, cutoff=DEFAULT_CUTOFF, max_contacts=None):
    """ Visualize score csv 
        selection: Selection for visualization
        floor: minimal score for visualization
        cutoff: minimal distance between amino acids
        scores: scores file for visualization
    """
    cutoff = int(cutoff)
    floor = float(floor)
    scores = read_scores(scores)
    
    max_contacts = int(max_contacts)
    if max_contacts is None or max_contacts == -1:
        max_contacts = len(scores)

    # filter for cutoff
    scores = list(filter(lambda x: x[1] - x[0] >= cutoff, scores))

    # filter for score floor
    scores = list(filter(lambda x: x[2] >= floor, scores))

    # show distances
    counter = 0
    for score in scores:    
        if counter > max_contacts:
            print("max contacts reached! (%s contacts not shown)" % (len(scores)-int(max_contacts)))
            break
        print("new msa contact between %s and %s" % (score[0], score[1]))
        name = "msa{}-{}_{:.3f}".format(score[0], score[1], score[2])
        seleA = "resid %s and n. CA and %s" % (score[0], selection)
        seleB = "resid %s and n. CA and %s" % (score[1], selection)
        if cmd.select("seleA", seleA) == "0" or cmd.select("seleB", seleB) == "0":
            continue
        cmd.distance(name, seleA, seleB)
        counter += 1
        
    cmd.delete('seleA')
    cmd.delete('seleB')


def read_scores(scores_file):
    scores = []
    if not isinstance(scores_file, file):
        scores_file = open(scores_file, 'r')
    for line in scores_file.readlines():
        split = line.split(",")
        resA = int(split[0])
        resB = int(split[1])
        score = float(split[2])
        dist = abs(resB - resA)
        scores.append([resA, resB, score, dist])
    scores_file.close()
    return scores

def remove_scores():
    cmd.delete("msa*")
cmd.extend("remove_scores", remove_scores)    
cmd.extend("show_scores", show_scores)
