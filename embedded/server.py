import serial
import sqlite3

ser = serial.Serial(
  port='/dev/ttyUSB0',
  baudrate=115200,
  parity=serial.PARITY_NONE,
  stopbits=serial.STOPBITS_ONE,
  bytesize=serial.EIGHTBITS,
  timeout=None)  # Changed timeout to None

print("connected to: " + ser.portstr)
count=1
db = sqlite3.connect('data.db')
cursor = db.cursor()
# check if the table exists
cursor.execute('''CREATE TABLE IF NOT EXISTS data (id INTEGER PRIMARY KEY, did TEXT, sid TEXT, type TEXT, value TEXT, time TEXT)''')
db.commit()
db.close()

while True:
  line = ser.readline()
  line = line.decode('utf-8').strip()  # Added strip() to remove trailing newline
  if line:  # Only print if line is not empty
    db = sqlite3.connect('data.db')
    cursor = db.cursor()
    cursor.execute('''INSERT INTO data (did, sid, type, value, time) VALUES (?, ?, ?, ?, datetime('now'))''', line['did'], line['sid'], line['t'], line['state'])
    db.commit()
    db.close()
    print(f"{count}: {line}")
    count += 1