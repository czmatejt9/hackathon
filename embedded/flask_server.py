import flask
import sqlite3

app = flask.Flask(__name__)
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
  
  return data, 200

if __name__ == '__main__':
    app.run(host='0.0.0.0')