"""
@author: Erik Andres Escayola 
@title: update input data files BEAR
@description:
  1. Import source and target files
  2. Replace values
  3. Update/save files
"""


# %% Preamble
import os
import pandas as pd

WDPATH = "P:\\ECB business areas\\DGI\\Databases and Programme files\\EXT\\ST_LATAM\\models\\bvar"
os.chdir(WDPATH)


# %% Import and wrangle 

for i in ["bra", "mex", "esp"]:

    df = pd.read_excel("epu"+i+"_comb.xlsx", index_col=0)
    
    df = df.iloc[:,2:]
    df = df.fillna(method="ffill")
    dfq = df.groupby(pd.PeriodIndex(df.index, freq="Q"), axis=0).mean()
    
    tmp = list(dfq.columns)
    for j in range(len(tmp)):
        tmp[j] = tmp[j].replace("epu"+i, "02epu_")
        tmp[j] = tmp[j] + "_lvl"
    dfq.columns = tmp
    
    dfq = dfq.loc[(dfq.index > "2002Q4") & (dfq.index <= "2019Q4")] 
    
    dfq = dfq.dropna(axis=1)  # thresh=60
    
    if i == "mex":
        cc = i.replace("e", "")
        cc = cc[0:2].upper()
    else:
        cc = i[0:2].upper()
        
    dfq.to_csv(os.path.join(WDPATH, cc+"_EPU.csv"))
