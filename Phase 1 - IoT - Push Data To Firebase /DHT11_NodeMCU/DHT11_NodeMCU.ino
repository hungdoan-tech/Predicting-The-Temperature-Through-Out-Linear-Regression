#include <ESP8266WiFi.h>                                                    // esp8266 library
#include <DHT.h>                                                            // dht11 temperature and humidity sensor library
#include <FirebaseArduino.h>                                                // firebase library
#include <NTPClient.h>
#include <WiFiUdp.h>

#define FIREBASE_HOST "atest-581aa.firebaseio.com"                          // the project name address from firebase id
#define FIREBASE_AUTH "1CYCCBDVR425k89MLPJ0oY32HYWJC8qFlxwTWqer"            // the secret key generated from firebase

#define WIFI_SSID "FY"                                                      // input your home or public wifi name
#define WIFI_PASSWORD "01101001"                                            // password of wifi ssid

// Define NTP Client to get time
WiFiUDP ntpUDP;
NTPClient timeClient(ntpUDP);

// Variables to save date and time
String formattedDate;
String dayStamp;
String timeStamp;

#define DHTPIN D4                                                           // what digital pin we're connected to 
// Chân DATA nối với chân D4
#define DHTTYPE DHT11                                                       // select dht type as DHT 11 or DHT22

// Khởi tạo cảm biến
DHT dht(DHTPIN, DHTTYPE);

void setup()
{
  Serial.begin(9600);
  Serial.println("DHT11 test!");
  connectWifi();
  delay(1000);
  Firebase.begin(FIREBASE_HOST, FIREBASE_AUTH);                              // connect to firebase
  dht.begin();                                                               // Bắt đầu đọc dữ liệu
}

void loop()
{
  delay(5000);
  showTemperatureAndHumid();
}

void connectWifi()
{
  Serial.println("Wait wifi connect!");
  WiFi.begin(WIFI_SSID, WIFI_PASSWORD);                                      // try to connect with wifi
  Serial.print("Connecting to ");
  Serial.print(WIFI_SSID);
  while (WiFi.status() != WL_CONNECTED) {
    Serial.print(".");
    delay(500);
  }
  Serial.println();
  Serial.print("Connected to ");
  Serial.println(WIFI_SSID);
  Serial.print("IP Address is : ");
  Serial.println(WiFi.localIP());                                            // print local IP address
  // In ra dia chi IP
  Serial.println(WiFi.localIP());
  // Initialize a NTPClient to get time
  timeClient.begin();
  timeClient.setTimeOffset(+7 * 60 * 60);
}

void showTemperatureAndHumid()
{
  while (!timeClient.update()) {
    timeClient.forceUpdate();
  }
  formattedDate = timeClient.getFormattedDate();
  // Extract date
  formattedDate.replace("T", " ");
  formattedDate.remove(19, 1);
  //Serial.println(formattedDate);
  // Đọc giá trị nhiệt độ C (mặc định)
  float t = dht.readTemperature();                                             // Read temperature as Celsius (the default)
  float h = dht.readHumidity();
  StaticJsonBuffer<200> jsonBuffer;
  JsonObject& root = jsonBuffer.createObject();
  root["date"] = formattedDate;
  root["temperature"] = t;
  root["humidity"] = h;
  //Serial.println(t);
  Firebase.push("/Data", root);
}
