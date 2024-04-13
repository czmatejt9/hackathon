// based on https://gist.github.com/yaqwsx/ac662c9b600ef39a802da0be1b25d32d
// 2018.07.14 jnogues@gmail.com, Jaume Nogués, rPrim Tech
// This sketch shows the use of 802.11 LR (Low Rate)
// master.ino

#include <Arduino.h>
#include <esp_now.h>
#include <WiFi.h>
#include <esp_wifi.h>

#include "pb_decode.h"
#include "protocol.pb.h"

void OnDataRecv(const uint8_t *mac_addr, const uint8_t *data, int data_len) {
    if (data_len == 0 || data[0] == 0) {
        return; // Ignore empty or invalid messages
    }

    int len = 0;
    for (int i = 0; i < data_len; i++) {
      if (data[i] == 0) {
        len = i;
        break;
      }
    }

    // Decode received message
    PushSensorState ns = PushSensorState_init_zero;
    pb_istream_t stream = pb_istream_from_buffer(data, len);
    if (!pb_decode(&stream, PushSensorState_fields, &ns)) {
        Serial.println("Decoding failed");
        return;
    }

    // Print the decoded message
    printf("{\"did\": \"%s\", \"sid\": \"%s\", \"t\": \"%s\", \"state\": \"%s\"}\n", ns.device_id, ns.sensor_id, ns.sensor_type, ns.state);
}

void setup() {
    Serial.begin( 115200 );
    
    WiFi.mode( WIFI_STA );
    esp_wifi_set_protocol( WIFI_IF_AP, WIFI_PROTOCOL_LR );

    if (esp_now_init() != ESP_OK) {
        Serial.println("ESP-NOW initialization failed");
        ESP.restart();
    }

    esp_now_register_recv_cb(OnDataRecv);
    
    // Add broadcast peer (all zeros)
    uint8_t broadcastAddress[] = {0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF};
    esp_now_peer_info_t peerInfo = {};
    memcpy(peerInfo.peer_addr, broadcastAddress, 6);
    peerInfo.channel = 0;  // Use default channel
    peerInfo.encrypt = false; // No encryption for broadcast
    if (esp_now_add_peer(&peerInfo) != ESP_OK) {
        Serial.println("Failed to add broadcast peer");
        ESP.restart();
    }
}

void loop() 
{
    
}
