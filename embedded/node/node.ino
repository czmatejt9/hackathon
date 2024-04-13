#include <Arduino.h>
#include <esp_now.h>
#include <WiFi.h>
#include <esp_wifi.h>
#include "DHT.h"
#include "pb_encode.h"
#include "pb_decode.h"
#include "protocol.pb.h"

#define DHTPIN 4     // Digital pin connected to the DHT sensor
#define DHTTYPE DHT11   // DHT 11

DHT dht(DHTPIN, DHTTYPE);

#define MAX_MESSAGE_IDS 50
#define MAX_MESSAGE_ID_LENGTH 20 // Adjust the length as needed

char* generateMessageIdFromDeviceId(const char* deviceId, uint64_t messageNumber) {
    static char messageId[MAX_MESSAGE_ID_LENGTH];

    // Generate the message ID using the device ID and message number
    snprintf(messageId, sizeof(messageId), "%s_%llu", deviceId, messageNumber);

    return messageId;
}

char messageIdPrefix[] = "1234_"; // Prefix for the message ID
uint64_t messageIdCounter = 0; // Counter to auto-increment the message ID

char* generateMessageId() {
    static char messageId[MAX_MESSAGE_ID_LENGTH];

    // Copy the prefix to the message ID
    strcpy(messageId, messageIdPrefix);

    // Convert the counter to a string and append it to the message ID
    char counterStr[20]; // Assuming 20 characters are enough to store a 64-bit integer
    snprintf(counterStr, sizeof(counterStr), "%llu", messageIdCounter);
    strcat(messageId, counterStr);

    // Increment the counter for the next message ID
    messageIdCounter++;

    return messageId;
}

char messageIds[MAX_MESSAGE_IDS][MAX_MESSAGE_ID_LENGTH + 1]; // +1 for null terminator
int currentIndex = 0; // Index to keep track of the current position in the rolling buffer

void addMessageId(const char* messageId) {
    // Copy the new message ID to the current position in the rolling buffer
    strncpy(messageIds[currentIndex], messageId, MAX_MESSAGE_ID_LENGTH);
    messageIds[currentIndex][MAX_MESSAGE_ID_LENGTH] = '\0'; // Ensure null termination

    // Update the current index for the next message
    currentIndex = (currentIndex + 1) % MAX_MESSAGE_IDS; // Wrap around if reached the end
}

bool hasId(const char* messageId) {
    // Iterate through the rolling buffer to check if the message ID exists
    for (int i = 0; i < MAX_MESSAGE_IDS; i++) {
        if (strcmp(messageIds[i], messageId) == 0) {
            return true; // Message ID found
        }
    }
    return false; // Message ID not found
}

void OnDataSent(const uint8_t *mac_addr, esp_now_send_status_t status) {
    if (status == ESP_NOW_SEND_SUCCESS) {
        Serial.println("Message sent successfully");
    } else {
        Serial.println("Error sending message");
    }
}

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

    if (hasId(generateMessageIdFromDeviceId(ns.device_id, ns.messageid))) {
      return;
    }

    addMessageId(generateMessageIdFromDeviceId(ns.device_id, ns.messageid));

    uint8_t mac[] = {0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF}; // Broadcast address
    esp_err_t result = esp_now_send(mac, data, data_len);
    if (result != ESP_OK) {
        Serial.println("Error sending message");
    }

    digitalWrite(LED_BUILTIN, !digitalRead(LED_BUILTIN));
    delay(75);
    digitalWrite(LED_BUILTIN, !digitalRead(LED_BUILTIN));
}

void setup() {
    Serial.begin(115200);
    pinMode(LED_BUILTIN, OUTPUT);
    //pinMode(36, INPUT);
    
    // Initialize WiFi in STA mode with LR protocol
    WiFi.mode(WIFI_STA);
    esp_wifi_set_protocol(WIFI_IF_STA, WIFI_PROTOCOL_LR);
    
    // Initialize ESP-NOW
    if (esp_now_init() != ESP_OK) {
        Serial.println("ESP-NOW initialization failed");
        ESP.restart();
    }

    for (int i = 0; i < MAX_MESSAGE_IDS; i++) {
        messageIds[i][0] = '\0'; // Null terminate each string
    }
    
    // Register callback for sending data
    esp_now_register_send_cb(OnDataSent);
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
    
    // Initialize DHT sensor
    dht.begin();
}

uint8_t buf[PushSensorState_size];
char statebuf[128];

void loop()
{
    if (millis() % 2000 == 0) {
      float h = dht.readHumidity();
      float t = dht.readTemperature();

      sprintf(statebuf, "H%f|T%f", h, t);

      PushSensorState ns = PushSensorState_init_zero;

      strcpy(ns.device_id, "1234");
      strcpy(ns.sensor_id, "5678");
      strcpy(ns.sensor_type, "DHT-11");
      strcpy(ns.state, statebuf);
      ns.messageid = messageIdCounter;

      uint8_t mac[] = {0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF}; // Broadcast address

       memset(buf, 0, sizeof(buf));
      pb_ostream_t stream = pb_ostream_from_buffer(buf, sizeof(buf));
      pb_encode(&stream, PushSensorState_fields, &ns);

      esp_err_t result = esp_now_send(mac, buf, sizeof(buf));
      if (result != ESP_OK) {
          Serial.println("Error sending message");
      } else {
        addMessageId(generateMessageId());
      }
/*
      sprintf(statebuf, "M%d", analogRead(36));

      strcpy(ns.device_id, "2345");
      strcpy(ns.sensor_id, "7890");
      strcpy(ns.sensor_type, "MIC");
      strcpy(ns.state, statebuf);
      ns.messageid = messageIdCounter;

      memset(buf, 0, sizeof(buf));
      stream = pb_ostream_from_buffer(buf, sizeof(buf));
      pb_encode(&stream, PushSensorState_fields, &ns);

      result = esp_now_send(mac, buf, sizeof(buf));
      if (result != ESP_OK) {
          Serial.println("Error sending message");
      } else {
        addMessageId(generateMessageId());
      }
*/
      digitalWrite(LED_BUILTIN, !digitalRead(LED_BUILTIN));
      delay(75);
      digitalWrite(LED_BUILTIN, !digitalRead(LED_BUILTIN));
    }
}
