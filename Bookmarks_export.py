import arcpy
import shutil
import os
Map = r"C:\\_Model\Sustainibility_C_Model.mxd"
# Script arguments
Cesta = arcpy.GetParameterAsText(0)
if Cesta == '#' or not Cesta:
    Cesta = "C:\\_Model\\Output\\" # provide a default value if unspecified
#Process clear directory - delete - create - os.mkdir(Cesta)
shutil.rmtree(Cesta, ignore_errors=True)
if not os.path.exists(Cesta):
    os.makedirs(Cesta)
mxd = arcpy.mapping.MapDocument(Map)
df = arcpy.mapping.ListDataFrames(mxd, "Map")[0]
for bkmk in arcpy.mapping.ListBookmarks(mxd, data_frame=df):
    df.extent = bkmk.extent
    outJPG = r"C:\_Model\Output\\" + bkmk.name + ".jpg"
#    outPDF = r"C:\_Model\Output\\" + bkmk.name + ".pdf"
    arcpy.mapping.ExportToJPEG(mxd, outJPG, df)
#    arcpy.mapping.ExportToPDF(mxd, outPDF, df, df_export_width=1600,df_export_height=1200)
del mxd
