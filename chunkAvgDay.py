import os
import math

numFiles = 115

path_comm = os.getenv('DATACOMM')
path_csv = os.getenv('DATACSV')
path_szn = os.getenv('DATAAVGDAY')
print(path_csv)

csv_fn = os.listdir(path_csv)
avgday_fn = os.listdir(path_szn)

csv = [file[:-15] for file in csv_fn if file[-4:]=='.csv']
avgday = [file[:-11] for file in avgday_fn if file[-4:]=='.csv']

new_cmds = [line + "-timeSeries.csv" for line in csv if line not in avgday]

numLines = len(new_cmds)
print(numLines)
if numLines > 1:
    if numLines < numFiles:
        numFiles = numLines
    chunkLines = math.ceil(numLines/numFiles)
    if chunkLines>1:
        for i in range (numFiles):
            if i == 0:
                ln = new_cmds[i*chunkLines:(i+1)*chunkLines]
            else:
                ln = new_cmds[(i*chunkLines)+1:(i+1)*chunkLines]
            filename = path_comm +'/inputSZN_' + str(i) + '.txt'
            f = open(filename, 'w')
            f.writelines( "%s\n" % item for item in ln )
            f.close()
    else:            
        ln = new_cmds
        filename = path_comm +'/inputSZN_1.txt'
        f = open(filename, 'w')
        f.writelines( "%s\n" % item for item in ln )
        f.close()
