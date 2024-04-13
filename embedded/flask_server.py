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
  return (flask.jsonify(data), 200)

if __name__ == '__main__':
    app.run(host='0.0.0.0')