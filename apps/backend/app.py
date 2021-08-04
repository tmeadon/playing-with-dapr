from dapr.clients import DaprClient
from http import HTTPStatus
from flask import Flask, request
from dapr.clients import DaprClient
from flask.wrappers import Response
import json

app = Flask(__name__)

@app.route('/http/<id>', methods = ['GET'])
def getFromHttpBackend(id):
    return getState('backend0', id).data

@app.route('/pubsub/<id>', methods = ['GET'])
def getFromPubsubBackend(id):
    return getState('backend1', id).data


@app.route('/httpReceive/<id>', methods = ['POST'])
def httpReceive(id):
    print("received via http {0}".format(request.data), flush=True)
    saveState('backend0', id, request.data)
    return request.get_json()

@app.route('/pubsubReceive', methods = ['POST'])
def pubsubReceive():
    body = request.json
    print("received via pubsub: {}".format(body), flush=True)
    data = json.loads(body['data'])
    print("received via pubsub: {}".format(data), flush=True)
    saveState('backend1', data['id'], json.dumps(data['value']))
    return Response({'success':True}, HTTPStatus.OK, {'ContentType':'application/json'})

def saveState(backendName, key, value):
    with DaprClient() as d:
        d.save_state(store_name=backendName, key=str(key), value=value)
        print("saved state to {0} - {1}".format(backendName, str(value)), flush=True)

def getState(backendName, key):
    with DaprClient() as d:
        return d.get_state(backendName, key)

app.run()