from flask import Flask, request
from dapr.clients import DaprClient

app = Flask(__name__)

@app.route('/')
def hello_world():
    return 'Hey, we have Flask in a Docker container!'

@app.route('/<name>')
def hello_name(name):
    return "Hey {}".format(name)

@app.route('/sync')
def sendSynchronously():
    response = DaprClient.invoke_method(app_id='backend', method_name='httpReceive', content_type=request.content_type, data=request.data, http_verb='post')
    print(response.content_type, flush=True)
    print(response.text(), flush=True)

app.run()