from flask import Flask, request
from dapr.clients import DaprClient

app = Flask(__name__)

@app.route('/httpReceive', methods = ['POST'])
def httpReceive():
    print("received via http")
    return request.get_json()

@app.route('/pubsubReceive', methods = ['POST'])
def pubsubReceive():
    print("received via pubsub: {}".format(request.get_json()))

app.run()