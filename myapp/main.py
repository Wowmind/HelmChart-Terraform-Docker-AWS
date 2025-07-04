from flask import Flask

app = Flask(__name__)

@app.route('/')
def hello():
    return 'Dont stop, keep practising.. never stop, never settle'