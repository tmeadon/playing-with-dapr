from dapr.clients import DaprClient
from http import HTTPStatus
from flask import Flask, request
from dapr.clients import DaprClient
from flask.wrappers import Response

app = Flask(__name__)

@app.route('/httpReceive', methods = ['POST'])
def httpReceive():
    body = request.json
    print("received via http {0}".format(body), flush=True)
    
    return request.get_json()

@app.route('/pubsubReceive', methods = ['POST'])
def pubsubReceive():
    body = request.json
    print("received via pubsub: {}".format(body), flush=True)
    saveState('backend1', body["id"], request.data)
    return Response({'success':True}, HTTPStatus.OK, {'ContentType':'application/json'})

def saveState(backendName, key, value):
    with DaprClient() as d:
        d.save_state(store_name=backendName, key=str(key), value=value)
        print("saved state to {0} - {1}".format(backendName, str(value)), flush=True)

app.run()