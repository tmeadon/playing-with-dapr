from http import HTTPStatus
from flask import Flask, request
from dapr.clients import DaprClient
import json

from flask.wrappers import Response

app = Flask(__name__)

@app.route('/')
def hello_world():
    return 'Hey, we have Flask in a Docker container!'

@app.route('/<name>')
def hello_name(name):
    return "Hey {}".format(name)

@app.route('/sync/<id>', methods = ['GET'])
def getSyncStore(id):
    with DaprClient() as d:
        response = d.invoke_method(app_id='backend', method_name='http/{0}'.format(id), http_verb='get', data="")
        return response.text

@app.route('/async/<id>', methods = ['GET'])
def getAsyncStore(id):
    with DaprClient() as d:
        response = d.invoke_method(app_id='backend', method_name='pubsub/{0}'.format(id), http_verb='get', data="")
        return response.text

@app.route('/sync/<id>', methods = ['POST'])
def sendSynchronously(id):
    with DaprClient() as d:
        response = d.invoke_method(app_id='backend', method_name='httpReceive/{0}'.format(id), content_type=request.content_type, data=request.data, http_verb='post')
        print(response.content_type, flush=True)
        print(response.text(), flush=True)
        return response.text()

@app.route('/async/<id>', methods = ['POST'])
def sendAsynchronously(id):
    with DaprClient() as d:
        message = json.dumps({'id': id, 'value': request.json})
        d.publish_event(pubsub_name='servicebus', topic_name='backend', data=message)
        return Response(None, HTTPStatus.ACCEPTED)

app.run()