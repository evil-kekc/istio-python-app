from flask import Flask, render_template
import os
import socket

app = Flask(__name__)

VERSION = os.environ.get('VERSION', 'v2')
HOSTNAME = socket.gethostname()

@app.route('/')
def home():
    return render_template('index.html', version=VERSION, hostname=HOSTNAME)

@app.route('/api')
def api():
    return {
        'version': VERSION,
        'hostname': HOSTNAME
    }

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=8080)
