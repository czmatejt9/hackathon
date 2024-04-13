// based on https://gist.github.com/yaqwsx/ac662c9b600ef39a802da0be1b25d32d
// 2018.07.14 jnogues@gmail.com, Jaume Nogués, rPrim Tech
// This sketch shows the use of 802.11 LR (Low Rate)
// master.ino

#include <Arduino.h>
#include <WiFi.h>
#include <WiFiUdp.h>
#include <esp_wifi.h>

#include "pb_decode.h"
#include "protocol.pb.h"

const char* ssid = "kkkkk";//AP ssid
const char* password = "12345678";//AP password
WiFiUDP udp;

void setup() {
    pinMode(LED_BUILTIN, OUTPUT);//builtin Led, for debug
    digitalWrite(LED_BUILTIN, HIGH);
    Serial.begin( 115200 );
  
    //second, we start AP mode with LR protocol
    //This AP ssid is not visible whith our regular devices
    WiFi.mode( WIFI_AP );//for AP mode
    //here config LR mode
    int a= esp_wifi_set_protocol( WIFI_IF_AP, WIFI_PROTOCOL_LR );
    WiFi.softAP(ssid, password);
    delay( 1000 );
    digitalWrite(LED_BUILTIN, LOW); 
    udp.begin( 8888 );
}

int count = 0;

uint8_t buf[8128];

void loop() 
{
    int size = udp.parsePacket();
    if ( size == 0 )
        return;
    if (udp.available() < 1) {
      return;
    }
    
    udp.read(buf, 8128);
    if (buf[0] == 0 && buf[1] == 0) {
      return;
    }

    udp.flush();

    PushSensorState ns = PushSensorState_init_zero;
        
    pb_istream_t stream = pb_istream_from_buffer(buf, 43);
    
    bool stat = pb_decode(&stream, PushSensorState_fields, &ns);
    
    /* Check for errors... */
    if (!stat)
    {
        printf("Decoding failed: %s\n", PB_GET_ERROR(&stream));
        return;
    }
    
    /* Print the data contained in the message. */
    printf("{\"did\": \"%s\", \"sid\": \"%s\", \"t\": \"%s\", \"state\": \"%s\"}\n", ns.device_id, ns.sensor_id, ns.sensor_type, ns.state);
    
    digitalWrite(5, !digitalRead(5));//toggle Led
}
