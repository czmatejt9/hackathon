import flask
import sqlite3

app = flask.Flask(__name__)

@app.route('/')
def home():
  db = sqlite3.connect('data.db')
  cursor = db.cursor()
  cursor.execute('SELECT * FROM data ORDER BY id DESC LIMIT 1')
  data = cursor.fetchone()
  db.close()
  data = {
    'did': data[1],
    'sid': data[2],
    'type': data[3],
    'value': data[4],
    'time': data[5]
  }
  return data, 200

if __name__ == '__main__':
    app.run(host='0.0.0.0')