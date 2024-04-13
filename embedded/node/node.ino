#include <Arduino.h>
#include <WiFi.h>
#include <WiFiUdp.h>
#include <esp_wifi.h>
#include "DHT.h"

#include "pb_encode.h"
#include "protocol.pb.h"

#define DHTPIN 4     // Digital pin connected to the DHT sensor
// Feather HUZZAH ESP8266 note: use pins 3, 4, 5, 12, 13 or 14 --
// Pin 15 can work but DHT must be disconnected during program upload.

// Uncomment whatever type you're using!
#define DHTTYPE DHT11   // DHT 11
//#define DHTTYPE DHT22   // DHT 22  (AM2302), AM2321
//#define DHTTYPE DHT21   // DHT 21 (AM2301)

// Connect pin 1 (on the left) of the sensor to +5V
// NOTE: If using a board with 3.3V logic like an Arduino Due connect pin 1
// to 3.3V instead of 5V!
// Connect pin 2 of the sensor to whatever your DHTPIN is
// Connect pin 4 (on the right) of the sensor to GROUND
// Connect a 10K resistor from pin 2 (data) to pin 1 (power) of the sensor

// Initialize DHT sensor.
// Note that older versions of this library took an optional third parameter to
// tweak the timings for faster processors.  This parameter is no longer needed
// as the current DHT reading algorithm adjusts itself to work on faster procs.
DHT dht(DHTPIN, DHTTYPE);

const char* ssid = "kkkkk";//AP ssid
const char* password = "12345678";//AP password

WiFiUDP udp;

const char *toStr( wl_status_t status ) {
    switch( status ) {
    case WL_NO_SHIELD: return "No shield";
    case WL_IDLE_STATUS: return "Idle status";
    case WL_NO_SSID_AVAIL: return "No SSID avail";
    case WL_SCAN_COMPLETED: return "Scan compleded";
    case WL_CONNECTED: return "Connected";
    case WL_CONNECT_FAILED: return "Failed";
    case WL_CONNECTION_LOST: return "Connection lost";
    case WL_DISCONNECTED: return "Disconnected";
    }
    return "Unknown";
}

void setup(void)
{
  Serial.begin( 115200 );
    Serial.println( "Slave" );
    pinMode(5, OUTPUT);//bultin Led, for debug

    //We start STA mode with LR protocol
    //This ssid is not visible whith our regular devices
    WiFi.mode( WIFI_STA );//for STA mode
    //if mode LR config OK
    int a= esp_wifi_set_protocol( WIFI_IF_STA, WIFI_PROTOCOL_LR );
    if (a==0)
    {
      Serial.println(" ");
      Serial.print("Error = ");
      Serial.print(a);
      Serial.println(" , Mode LR OK!");
    }
    else//if some error in LR config
    {
      Serial.println(" ");
      Serial.print("Error = ");
      Serial.print(a);
      Serial.println(" , Error in Mode LR!");
    }
      
    WiFi.begin(ssid, password);//this ssid is not visible

    //Wifi connection, we connect to master
    while (WiFi.status() != WL_CONNECTED) 
    {
      delay(500);
      Serial.print(".");
    }

    Serial.println("WiFi connected");
    Serial.print("IP address: ");
    Serial.println(WiFi.localIP());
  
    udp.begin( 8888 );
    dht.begin();
  
}

uint8_t buf[8128];

void loop(void)
{
  if ( WiFi.status() != WL_CONNECTED ) 
    {
        Serial.println( "|" );
        int tries = 0;
        WiFi.begin( ssid, password );
        while( WiFi.status() != WL_CONNECTED ) {
            tries++;
            if ( tries == 5 )
                return;
            Serial.println( toStr( WiFi.status() ) );
            delay( 1000 );
        }
        Serial.print( "Connected " );
        Serial.println( WiFi.localIP() );
    }
    /*
    //if connection OK, execute command 'b' from master
    int size = udp.parsePacket();
  if (size > 0) {
    int str = udp.read();
    */

    if (millis() % 2000 == 0) {
      float h = dht.readHumidity();
      float t = dht.readTemperature();

      char htstate[1024];
      sprintf(htstate, "H%f|T%f", h, t);

      PushSensorState ns = PushSensorState_init_zero;

      strcpy(ns.device_id, "1234");
      strcpy(ns.sensor_id, "5678");
      strcpy(ns.sensor_type, "DHT-11");
      strcpy(ns.state, htstate);

      pb_ostream_t stream = pb_ostream_from_buffer(buf, sizeof(buf));
      pb_encode(&stream, PushSensorState_fields, &ns);

      udp.beginPacket({192,168,4,255}, 8888);
      printf("Length of buffer is %d/n", sizeof(buf));
      printf("Written: %d\n", stream.bytes_written);
      udp.write(buf, 8128);
      for(int i = 0; i < 16; i++) {
        Serial.print(buf[i]);
      }
      Serial.println();

      if ( !udp.endPacket() ){
        Serial.println("Failed to push sensor state!");
        delay(100);
        ESP.restart();
      }
      else{
            Serial.println("Pushed sensor state!"); 
      }
    }
}
