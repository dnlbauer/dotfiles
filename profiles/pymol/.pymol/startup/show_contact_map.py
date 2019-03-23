#!/usr/bin/env python

import tkFileDialog
import tkSimpleDialog
from pymol import cmd
import math
from distutils.util import strtobool

def __init__(self):
	self.menuBar.addmenuitem('Plugin', 'command', 'Contact map', label='Show contact map', command=lambda s=self: load_map(s))

def load_map(app):
	contacts_file = tkFileDialog.askopenfile(initialdir=".", title="Load contact map")
	if contacts_file is None:
		return
	show_contact_map(file=contacts_file)

def show_contact_map(selection="all", file=None, as_bonds=1, quiet=0):
	""" Visualize contact map
	"""
	as_bonds = bool(as_bonds)
	quiet = bool(quiet)
	contacts = read_contacts(file)

	for contact in contacts:	
		name = "contact{}-{}".format(contact[0], contact[1])
		seleA = "id %s and %s" % (contact[0], selection)
		seleB = "id %s and %s" % (contact[1], selection)
		
		# skip non-exsistant
		if cmd.select("seleA", seleA) == "0" or cmd.select("seleB", seleB) == "0":
			print("%s to %s not found!" % (seleA, seleB))

		if not quiet:
			print("New bond: residue %s to %s" % (contact[0], contact[1]))

		if as_bonds:
			cmd.bond(seleA, seleB)
		else:
			cmd.distance(name, seleA, seleB)

	cmd.delete('seleA')
	cmd.delete('seleB')


def read_contacts(contacts_file, separator=' '):
	contacts = []
	if not isinstance(contacts_file, file):
		contacts_file = open(contacts_file, 'r')
	for line in contacts_file.readlines():
		split = line.split(",")
		resA = int(split[0])
		resB = int(split[1])
		contacts.append([resA, resB])
	contacts_file.close()
	return contacts
	
cmd.extend("contact_map", show_contact_map)
