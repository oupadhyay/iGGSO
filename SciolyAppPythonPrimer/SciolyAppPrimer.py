import csv, json


outputPath = "package.json"

schedulesB = ["Schedules_B.csv"]
schedulesC = ["Schedules_C.csv"]
teamsB = ["Teams_B.csv"]
teamsC = ["Teams_C.csv"]

tournamentFiles = [schedulesB, schedulesC, teamsB, teamsC]


#Load the four CSV files into Python lists
for updateableFile in tournamentFiles:
    with open(updateableFile[0]) as csvFile:
        reader = csv.reader(csvFile)
        for row in reader:
            updateableFile.append(row)


#Create dictionary split by B/C Division
tournamentInformation = {
    "B": [],
    "C": []
}


#Add division B/C team numbers to tournamentInformation dictionary


#Return the time of a particular event
def getEventTime(division, teamNumber, eventNumber, eventName):

   #Check division
    if division == "B":

        #Check to see if the event is self scheduled
        if schedulesB[eventNumber+1][6].lower() == "ss" :

            #Find indices of the event time based of the event name and team number
            index1 = teamsB[1].index(eventName)
            index2 = teamNumber + 1

            return teamsB[index2][index1]

        #Check to see if everyone has the same time block
        elif schedulesB[eventNumber+1][5].lower() == "all":
            return schedulesB[1][5]

        #Get individual times. There are 6 possible time blocks ranging from index 6 to 12.
        else:
            for i in range (6,12):


                if int(roundTo10(teamNumber) + 1) == int(schedulesB[eventNumber+1][i]):
                    return schedulesB[1][i]

    if division == "C":

        # Check to see if the event is self scheduled
        if schedulesC[eventNumber + 1][6].lower() == "ss":

            # Find indices of the event time based of the event name and team number
            index1 = teamsC[1].index(eventName)
            index2 = teamNumber + 1

            return teamsC[index2][index1]

        # Check to see if everyone has the same time block
        elif schedulesC[eventNumber + 1][5].lower() == "all":
            return schedulesC[1][5]

        # Get individual times. There are 6 possible time blocks ranging from index 6 to 12.
        else:
            for i in range(6, 12):

                if int(roundTo10(teamNumber) + 1) == int(schedulesC[eventNumber + 1][i]):
                    return schedulesC[1][i]

    return "NA"


#Rounding function to aid in event times.
def roundTo10(num):
    return num - (num%10)


#Populate the tournament information dictionary with division B information
for i in range(2, len(teamsB)):
    tournamentInformation["B"].append(
        {
            "teamNumber": str(int(teamsB[i][1])),
            "teamName": teamsB[i][0],
            "homeroom": teamsB[i][2],
            "events":
                []

        })
    for j in range(len(schedulesB)-2):
        tournamentInformation["B"][i - 2]["events"].append(
            {
                "eventName": schedulesB[j + 2][0],
                "eventNumber": j+1,
                "trialStatus": "Yes" if schedulesB[j + 2][2].lower() == "yes" else "No",

                "impoundStatus": "Yes" if schedulesB[j + 2][4] != "" else "No",
                "impoundTime": schedulesB[j + 2][4] if schedulesB[j + 2][4] != "" else "NA",
                "impoundLocation": schedulesB[j + 2][3] if schedulesB[j + 2][3] != "" else "NA",

                "eventTime": getEventTime("B", int(teamsB[i][1]), j+1, schedulesB[j + 2][0])

        })

#Populate the tournament information dictionary with division C information
for i in range(2, len(teamsC)):
    tournamentInformation["C"].append(
        {
            "teamNumber": str(int(teamsC[i][1])),
            "teamName": teamsC[i][0],
            "homeroom": teamsC[i][2],
            "events":
                []

        })
    for j in range(len(schedulesC)-2):
        tournamentInformation["C"][i - 2]["events"].append(
            {
                "eventName": schedulesC[j + 2][0],
                "eventNumber": j+1,
                "trialStatus": "Yes" if schedulesC[j + 2][2].lower() == "yes" else "No",

                "impoundStatus": "Yes" if schedulesC[j + 2][4] != "" else "No",
                "impoundTime": schedulesC[j + 2][4] if schedulesC[j + 2][4] != "" else "NA",
                "impoundLocation": schedulesC[j + 2][3] if schedulesC[j + 2][3] != "" else "NA",

                "eventTime": getEventTime("C", int(teamsC[i][1]), j+1, schedulesC[j + 2][0])

        })



#Convert Python dictionary to JSON file for the app.
with open (outputPath, "w") as f:
    json.dump(tournamentInformation, f)


    print(tournamentInformation)














