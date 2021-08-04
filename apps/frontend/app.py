from flask import Flask, request
from dapr.clients import DaprClient
import json

app = Flask(__name__)

@app.route('/')
def hello_world():
    return 'Hey, we have Flask in a Docker container!'

@app.route('/<name>')
def hello_name(name):
    return "Hey {}".format(name)

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
        message = json.dumps({'id': id, 'value': request.data})
        d.publish_event(pubsub_name='servicebus', topic_name='backend', data=message)

app.run()