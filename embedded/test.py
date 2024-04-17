import requests

url = "https://api.netatmo.com/api/getpublicdata?lat_ne=49.2958042&lon_ne=16.7348103&lat_sw=49.1024250&lon_sw=16.4429861&required_data=temperature&filter=false"
api_key = "661eb9509c23e7ba3e0933fd|49428dd03a98450c123cd2c4c4422344"
head = {
    "clientId" : "66200779bda71e57730f9818",
    "clientSecret" : "lP5UqBUpOCDISoUr59fgTzar9dIqLQ0yI6",
    "Authorization" : f"Bearer {api_key}",
    "accept" : "application/json"
}
res = requests.get(url, headers=head)
print(res.status_code, res.content)
values = res.json()

for each in values["body"]:
    lon, lat = each["place"]["location"]
    #city, street = each["place"]["city"], each["place"]["street"]
    measurements: dict = each["measures"]
    measurement_data = ""
    for values in measurements.values():
        if not values.get("res", 0):
            continue
        nums = values["res"]
        nums = list(nums.values())
        nums = nums[0]
        for num, type in zip(nums , values["type"]):
            measurement_data += str(num)
            measurement_data += type
            measurement_data += ","


    print(lat, lon, measurement_data)