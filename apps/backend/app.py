from flask import Flask, request
from dapr.clients import DaprClient

app = Flask(__name__)

@app.route('/httpReceive')
def httpReceive():
    return request.get_json()

app.run()