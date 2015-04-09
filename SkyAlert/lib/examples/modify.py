# Copyright 2010 Roy D. Williams
"""
modify: Sample program for use with VOEvent library.
Reads a VOEvent file and does some modifications, then output.
See the VOEvent specification for details
http://www.ivoa.net/Documents/latest/VOEvent.html
"""

import sys
import VOEvent
from Vutil import *

if len(sys.argv) > 1:
    filename = sys.argv[1]
else:
    print "Usage: python modify.py <filename>"
    sys.exit(1)

# parse the event from the file name
v = parse(filename)

# set the ivorn to something else
v.set_ivorn('ivo://sample/survey#123')

# set the author
v.get_Who().get_Author().set_contactName(['Mickey Mouse'])

# look for a specific param in the event
param = findParam(v, '', 'EVENT_ID')
if param:
    val = param.get_value()
    print "val is %s" % val

# change the value of the param
    param.set_value(873646)
    val = param.get_value()
    print "val is %s" % val

# get the first table, if there is one
tables = v.get_What().get_Table()
if len(tables) == 1:

# make a utilityTable
    utable = utilityTable(tables[0])

# get all the table entries
    colList = utable.getByCols()
    for (name, vect) in colList.items():
        print 'column', name, '=', vect

# replace current tabel data with 12 rows all empty
    utable.blankTable(12)

# set up some values
    for i in range(12):
        utable.setValue('RA', i, i/100.0)

    print utable.toString()

# print the XML
v.export(sys.stdout, 0)
