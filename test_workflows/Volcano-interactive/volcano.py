import math
import numpy as np
import pandas as pd
from pathlib import Path
import plotly.express as px
import plotly.io as io
import sys

### data -> after ttest
file_path = sys.argv[1]
output_path = sys.argv[2]

file_path = Path(file_path)
file_extension = file_path.suffix.lower()[1:]

db = pd.read_excel(file_path, engine='openpyxl')

log_base_fc = (sys.argv[2])#2
log_base_p = int(sys.argv[3])#10
thres_fc = float(sys.argv[4])#2
thres_p = float(sys.argv[5])#0.05

if log_base_fc == 10:
    log_fc = np.log10(db["FC_HCC_divided_by_C"])
    log_thres_fc = np.log10(thres_fc)
else:
    log_fc = np.log2(db["FC_HCC_divided_by_C"])
    log_thres_fc = np.log2(thres_fc)

if log_base_p == 10:
    log_p = np.log10(db["p"])*-1
    log_padj = np.log10(db["p.fdr"])*-1
    log_thres_p = np.log10(thres_p)*-1
else:
    log_p = np.log2(db["p"])*-1
    log_padj = np.log2(db["p.fdr"])*-1
    log_thres_p = np.log2(thres_p)*-1

groups = []

for p, pa, f in zip(log_p, log_padj, log_fc):
    if np.isnan(p) | np.isnan(f):
        groups.append(np.nan)
    elif (pa >= log_thres_p) & ((f > log_thres_fc ) | (f < log_thres_fc*-1)):
        groups.append("significant after FDR correction")
    elif (p >= log_thres_p) & ((f > log_thres_fc) | (f < log_thres_fc*-1)) & (pa < log_thres_p):
        groups.append("significant")
    else:
        groups.append("not significant")

dataset = { 
    "id" : db["Accession"],   
    "p"  : log_p,
    "fc" : log_fc,
    "group" : groups}

maxX = log_fc.max()
minX = log_fc.min()

if maxX > minX*-1:
    x_axis = math.ceil(maxX)
else:
    x_axis = math.ceil(minX*-1)

color_discrete_map = {'significant after FDR correction': 'orange', 'significant': 'black', 'not significant': 'rgb(193,205,205)'}

fig = px.scatter(dataset, x="fc", y="p", color="group", hover_name = "id", color_discrete_map=color_discrete_map)

fig.add_hline(y=log_thres_p,     line_color="grey", line_dash="dot")
fig.add_vline(x=log_thres_fc,    line_color="grey", line_dash="dot")
fig.add_vline(x=log_thres_fc*-1, line_color="grey", line_dash="dot")

fig.update_xaxes(range=[x_axis*-1,x_axis])
fig.update_layout({"plot_bgcolor": "rgba(0, 0, 0, 0)"})

#fig.show()

io.write_json(fig, output_path)