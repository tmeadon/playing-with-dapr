from dapr.clients import DaprClient
from http import HTTPStatus
from flask import Flask, request
from dapr.clients import DaprClient
from flask.wrappers import Response

app = Flask(__name__)

@app.route('/httpReceive/<id>', methods = ['POST'])
def httpReceive(id):
    print("received via http {0}".format(request.data), flush=True)
    saveState('backend0', id, request.data)
    return request.get_json()

@app.route('/pubsubReceive', methods = ['POST'])
def pubsubReceive():
    body = request.json
    print("received via pubsub: {}".format(body), flush=True)
    id = body['data']['id']
    value = body['data']["value"]
    print("received via pubsub: {}".format(body), flush=True)
    saveState('backend1', id, value)
    return Response({'success':True}, HTTPStatus.OK, {'ContentType':'application/json'})

def saveState(backendName, key, value):
    with DaprClient() as d:
        d.save_state(store_name=backendName, key=str(key), value=value)
        print("saved state to {0} - {1}".format(backendName, str(value)), flush=True)

app.run()