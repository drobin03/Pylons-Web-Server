import logging
import json

from pylons import request, response, session, tmpl_context as c, url
from pylons.controllers.util import abort, redirect

from networkingserver.lib.base import BaseController, render

log = logging.getLogger(__name__)


characters = {'fox': '/img/fox.gif',
		'peppy': '/img/peppy.gif'}
message = ""

class MaincontrollerController(BaseController):

    def index(self):
	global characters;
	global message
	c.characters = characters;
	c.message = message
        # Return a rendered template
        #return render('/login.mako')
        # or, return a response
	if (request.method == 'GET'):
		return render('/index.mako')
	else:
		return request.method;

    def users(self, userid):
	global characters
	global message
	c.characters = characters
	c.message = message
	if (request.method == 'GET'):
		if 'userid' in request.params:
			c.userid = request.params['userid']
	    	else:
			c.userid = userid

		if (characters[c.userid]):
			c.image = characters[c.userid]
		else:
			c.userid = "nobody"
		return json.dumps({ 'userid': c.userid, 'image': c.image })

	elif (request.method == 'POST'):
		# Add character
		if 'userid' in request.params:
			c.userid = request.params['userid']
			c.image = request.params['image']
		else:
			c.userid = userid
			c.image = request.params['image']

		if (c.userid in characters):
			# duplicate
			c.message = "That character already exists, please choose another name."
		else:
			characters[c.userid] = c.image
			c.message = "Successfully added %s" % c.userid

		return c.message;	
	elif (request.method == 'DELETE'):
		if 'userid' in request.params:
			c.userid = request.params['userid']
		else:
			c.userid = userid

		if (c.userid in characters):
			del characters[c.userid]
			c.message = "Successfully deleted %s" % c.userid
		else:
			c.message = "%s does not exist" % c.userid

		return c.message
	else:
		return request.method;

    def play(self, userid):
	global characters
	global message
	c.characters = characters
	c.message = message
	if 'userid' in request.params:
		c.userid = request.params['userid']
    	else:
		c.userid = userid

	if (characters[c.userid]):
		c.image = characters[c.userid]
	else:
		c.userid = "nobody"
	return render('/play.mako')

    def message(self, msg):
	global message

	if (request.method == "POST"):
		if (msg != ''):
			message = msg
	elif (request.method == "DELETE"):
		message = ''
	else:
		# Not supported
		return

