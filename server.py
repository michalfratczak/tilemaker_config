#!/usr/bin/env python

import os
import sys
import shutil
import math
import traceback

import bottle

C_BLACK = 		"\033[1;30m"
C_RED = 		"\033[1;31m"
C_GREEN = 		"\033[1;32m"
C_BROWN = 		"\033[1;33m"
C_BLUE = 		"\033[1;34m"
C_MAGENTA = 	"\033[1;35m"
C_CYAN = 		"\033[1;36m"
C_LIGHTGREY = 	"\033[1;37m"
C_OFF =   		"\033[0m"
C_CLEAR =   	"\033[2K"

class EnableCors(object):
	name = 'enable_cors'
	api = 2
	def apply(self, fn, context):
		def _enable_cors(*args, **kwargs):
			# set CORS headers
			bottle.response.headers['Access-Control-Allow-Origin'] = '*'
			bottle.response.headers['Access-Control-Allow-Methods'] = 'GET, POST, PUT, OPTIONS'
			bottle.response.headers['Access-Control-Allow-Headers'] = 'Origin, Accept, Content-Type, X-Requested-With, X-CSRF-Token'
			# bottle.response.headers['Access-Control-Allow-Methods'] = '*'
			# bottle.response.headers['Access-Control-Allow-Headers'] = '*'

			if bottle.request.method != 'OPTIONS':
				return fn(*args, **kwargs)
		return _enable_cors


app = bottle.app()
app.install(EnableCors())
db = None




def get_tile_file(z,x,y):
	print 'get_tile_file ', (z,x,y)
	z = int(z)
	x = int(x)
	y = int(y)

	base_dir = sys.argv[1]

	path = base_dir + '/%d/%d/%d.pbf' % (z,x,y)

	if os.path.isfile(path):
		with open(path, 'rb') as fh:
			data = fh.read()
			print len(data),
			print C_GREEN, path, C_OFF
			return data
	else:
		print C_RED, path, C_OFF
		return None

	return None



@app.route('<filename>')
def server_static(filename):
    return bottle.static_file(filename, root='./static')


@app.route('/')
def hello():
    bottle.redirect("hab.html")


@app.get('/<x>/<y>/<z>.pbf', methods=['GET'])
def tiles(x=0, y=0, z=0):
	bottle.response.content_type = 'application/x-protobuf'
	# bottle.response.content_disposition = 'attachment' # https://github.com/openmaptiles/postserve/blob/master/server.py#L89

	# bottle.response.content_encoding = 'gzip'
	tile = get_tile_file(z, x, y)
	return tile
bottle.run(	host='localhost', port=3000, debug=True, reloader=True )