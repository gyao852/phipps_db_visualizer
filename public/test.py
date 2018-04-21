import csv
import inspect, os
csv_data=[]

with open('/Users/Ashvin/Desktop/phipps_db_visualizer/public/addressesfile.csv') as csvDataFile:
    csvReader = csv.reader(csvDataFile)
    for row in csvReader:
        csv_data += [row]
print(csv_data)

resultFile = open("/Users/Ashvin/Desktop/phipps_db_visualizer/public/result.csv",'w')
wr = csv.writer(resultFile)
for data in csv_data:
	print(data)
	wr.writerows([data])