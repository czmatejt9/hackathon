import serial

ser = serial.Serial(
  port='/dev/ttyUSB0',
  baudrate=115200,
  parity=serial.PARITY_NONE,
  stopbits=serial.STOPBITS_ONE,
  bytesize=serial.EIGHTBITS,
  timeout=None)  # Changed timeout to None

print("connected to: " + ser.portstr)
count=1

while True:
  line = ser.readline()
  line = line.decode('utf-8').strip()  # Added strip() to remove trailing newline
  if line:  # Only print if line is not empty
    print(f"{count}: {line}")
    count += 1