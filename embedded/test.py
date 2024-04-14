from math import radians, cos, sin, asin, sqrt
def distance(lat1, lat2, lon1, lon2):
    lat_dist = 110.7 * (lat1 - lat2)
    long_dist = 72.7 * (lon1 - lon2)
      
    # calculate the result
    return(sqrt(lat_dist**2 + long_dist**2))
     
     
# driver code 
lat1 = 16.696217
lon1 = 49.148972
lat2 = 16.6054065
lon2 =  49.1806396
print(distance(lat1, lat2, lon1, lon2), "K.M")