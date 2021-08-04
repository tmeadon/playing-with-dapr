from http import HTTPStatus
from flask import Flask, request
from dapr.clients import DaprClient
from flask.wrappers import Response

app = Flask(__name__)

@app.route('/httpReceive', methods = ['POST'])
def httpReceive():
    print("received via http", flush=True)
    return request.get_json()

@app.route('/pubsubReceive', methods = ['POST'])
def pubsubReceive():
    print("received via pubsub: {}".format(request.get_json()), flush=True)
    return Response({'success':True}, HTTPStatus.OK, {'ContentType':'application/json'})

app.run()