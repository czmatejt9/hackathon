import flask
import sqlite3
from flask_cors import CORS  # Import the flask_cors module

app = flask.Flask(__name__)
CORS(app)  # Enable CORS on your Flask application

def get_data(did, sid, cursor):
  cursor.execute('SELECT * FROM data WHERE did = ? AND sid = ? ORDER BY id DESC LIMIT 1', (did, sid))
  data = cursor.fetchone()
  return data

@app.route('/')
def home():
  db = sqlite3.connect('data.db')
  cursor = db.cursor()
  data_all = []
  data_all.append(get_data('1234', '5678', cursor))
  data_all.append(get_data('2345', '6789', cursor))
  data_all.append(get_data('2345', '7890', cursor))
  db.close()
  data = {
     "sensors": []
  }
  for d in data_all:
      if d:
        data["sensors"].append({
            "did": d[1],
            "sid": d[2],
            "type": d[3],
            "value": d[4],
            "time": d[5]
        })
  
  return flask.jsonify(data), 200  # Use flask.jsonify to return JSON response

if __name__ == '__main__':
    app.run(host='0.0.0.0')