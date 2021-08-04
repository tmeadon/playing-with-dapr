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
    with DaprClient() as d:
        d.save_state(store_name="backend0", key=body["id"], value=request.data)
        print("saved state to backend0", flush=True)
    return request.get_json()

@app.route('/pubsubReceive', methods = ['POST'])
def pubsubReceive():
    body = request.json
    print("received via pubsub: {}".format(body), flush=True)
    with DaprClient() as d:
        d.save_state(store_name="backend1", key=body["id"], value=request.data)
        print("saved state to backend1", flush=True)
    return Response({'success':True}, HTTPStatus.OK, {'ContentType':'application/json'})

app.run()