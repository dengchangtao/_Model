# -*- coding: utf-8 -*-
# ---------------------------------------------------------------------------
# model.py
# Created on: 2014-08-29 16:49:28.00000 by JaV
#   (generated by ArcGIS/ModelBuilder - completed with KomodoEdit 8.5)
# Usage: model <Cesta> 
# Description: Export C:\_Model\Model.mdb geodatabase to selected folder as ShapeFile
#               there is also difined limited export of certain fields
# ---------------------------------------------------------------------------

# Import arcpy module
import arcpy
import shutil
import os

# Script arguments
Cesta = arcpy.GetParameterAsText(0)
if Cesta == '#' or not Cesta:
    Cesta = "C:\\_Model\\Export\\" # provide a default value if unspecified
#Process clear directory - delete - create - os.mkdir(Cesta)
shutil.rmtree(Cesta, ignore_errors=True)
if not os.path.exists(Cesta):
    os.makedirs(Cesta)

# ---------------------- Local input variables:
C_Model = "C:\\_Model\\Model.mdb\\"
C_Mod_FC = C_Model + "mu_Geometry\\"
mw_Tank = C_Mod_FC + "mw_Tank"
mw_Pipe = C_Mod_FC + "mw_Pipe"
mw_Junction = C_Mod_FC + "mw_Junction"
mw_Valve = C_Mod_FC + "mw_Valve"
mw_Pump = C_Mod_FC + "mw_Pump"
mw_DemAlloc = C_Mod_FC + "mw_DemAlloc"
RES_Pressure_Qp = C_Model + "RES_Pressure_SS_Qp"
RES_Pressure_Qd = C_Model + "RES_Pressure_SS_Qd"
RES_Quality = C_Model + "RES_Quality_Age_SS_Qp"
RES_FFR6 = C_Model + "RES_FireFlow_6ls_SS"
RES_FFR9 = C_Model + "RES_FireFlow_9ls_SS"
# ---------------------- Local output variables:
Identif = "DC_ID"
Desc = "Descriptio"
Elevat = "ELEVATION"
# TANK - Enabled / MUID / Descriptio / ELEVATION / Diameter / 
mw_Tank_shp = Cesta + "mw_Tank.shp"
Divisio = "Type"
TankPat = "VOLCURVE"
Lvl = "LEVEL"
# PIPE - 
mw_Pipe_shp = Cesta + "mw_Pipe.shp"
# NODE - Enabled / MUID / Descriptio / Elev / PZoneID + ( DEMAND / PATTERN / DC_ID / PminQp / PmaxQp / PminQd / PmaxQd / Age / FireFlow6 / FireFlow9 )
Dem = "DEMAND"
Pat = "PATTERN"
QpPmin = "PminQp"
QpPmax = "PmaxQp"
QdPmin = "PminQd"
QdPmax = "PmaxQd"
Age = "Age"
FFR6 = "FireFlow6"
FFR9 = "FireFlow9"
mw_Junction_shp = Cesta + "mw_Junction.shp"
# VALVE - 
mw_Valve_shp = Cesta + "mw_Valve.shp"
# PUMP - 
mw_Pump_shp = Cesta + "mw_Pump.shp"
# DEMAND - 
mw_DemAlloc_shp = Cesta + "mw_DemAlloc.shp"

# Process: Tanks and reservoirs
arcpy.FeatureClassToFeatureClass_conversion(mw_Tank, Cesta, "mw_Tank.shp", "", \
	"Enabled \"Enabled\" true true true 2 Short 0 0 ,First,#," + mw_Tank + ",Enabled,-1,-1;\
	MUID \"MUID\" true true false 40 Text 0 0 ,First,#," + mw_Tank + ",MUID,-1,-1;\
	Descriptio \"Description\" true true false 255 Text 0 0 ,First,#," + mw_Tank + ",Description,-1,-1;\
	Elev \"Elev\" true true false 4 Float 0 0 ,First,#," + mw_Tank + ",Elev,-1,-1;\
	Diameter \"Diameter\" true true false 4 Float 0 0 ,First,#," + mw_Tank + ",Diameter,-1,-1;\
	Length \"Length\" true true false 4 Float 0 0 ,First,#," + mw_Tank + ",Length,-1,-1;\
	Width \"Width\" true true false 4 Float 0 0 ,First,#," + mw_Tank + ",Width,-1,-1;\
	MaxLevel \"MaxLevel\" true true false 4 Float 0 0 ,First,#," + mw_Tank + ",MaxLevel,-1,-1;\
	MinLevel \"MinLevel\" true true false 4 Float 0 0 ,First,#," + mw_Tank + ",MinLevel,-1,-1;\
	Volume \"ComVol\" true true false 4 Float 0 0 ,First,#," + mw_Tank + ",ComVol,-1,-1;\
	Type \"HGLTypeNo\" true true false 2 Short 0 0 ,First,#," + mw_Tank + ",HGLTypeNo,-1,-1", "")
# Process: Add fields
arcpy.AddField_management(mw_Tank_shp, Identif, "TEXT", "", "", "50", "", "NULLABLE", "NON_REQUIRED", "")
arcpy.AddField_management(mw_Tank_shp, Lvl, "FLOAT", "", "", "", "", "NULLABLE", "NON_REQUIRED", "")
arcpy.AddField_management(mw_Tank_shp, TankPat, "TEXT", "", "", "50", "", "NULLABLE", "NON_REQUIRED", "")
# Process: Calculate these fields - nefacha - arcpy.CalculateField_management(mw_Tank_shp, Identif, "MUID", "VB", "")
#vzor - arcpy.CalculateField_management(mw_Tank_shp, Identif, "\"bb\"", "VB", "")
#arcpy.AlterField_management(mw_Tank_shp, field, 'ELEVATION', 'Elevation in Metres')
#arcpy.JoinField_management(mw_Tank_shp, "MUID", mw_Tank, "MUID", "HGLTypeNo")
#arcpy.CalculateField_management(mw_Tank_shp, Divisio, "HGLTypeNo", "VB", "")
#arcpy.RemoveJoin_management(mw_Tank_shp, "HGLTypeNo")

# Process: Pipes
arcpy.FeatureClassToFeatureClass_conversion(mw_Pipe, Cesta, "mw_Pipe.shp", "", "", "")

# Process: Junctions - - Enabled / MUID / Descriptio / Elev / PZoneID + ( DEMAND / PATTERN / DC_ID / PminQp / PmaxQp / PminQd / PmaxQd / Age / FireFlow6 / FireFlow9 )
arcpy.FeatureClassToFeatureClass_conversion(mw_Junction, Cesta, "mw_Junction.shp", "", \
	"Enabled \"Enabled\" true true true 2 Short 0 0 ,First,#," + mw_Junction + ",Enabled,-1,-1;\
	MUID \"MUID\" true true false 40 Text 0 0 ,First,#," + mw_Junction + ",MUID,-1,-1;\
	Descriptio \"Description\" true true false 255 Text 0 0 ,First,#," + mw_Junction + ",Description,-1,-1;\
	ELEVATION \"Elev\" true true false 4 Float 0 0 ,First,#," + mw_Junction + ",Elev,-1,-1;\
	PZoneID \"PZoneID\" true true false 40 Text 0 0 ,First,#," + mw_Junction + ",PZoneID,-1,-1", "")
# Process: Junctions - Add Fields
arcpy.AddField_management(mw_Junction_shp, QpPmin, "FLOAT", "", "", "", "", "NULLABLE", "NON_REQUIRED", "")
arcpy.AddField_management(mw_Junction_shp, QpPmax, "FLOAT", "", "", "", "", "NULLABLE", "NON_REQUIRED", "")
arcpy.AddField_management(mw_Junction_shp, QdPmin, "FLOAT", "", "", "", "", "NULLABLE", "NON_REQUIRED", "")
arcpy.AddField_management(mw_Junction_shp, QdPmax, "FLOAT", "", "", "", "", "NULLABLE", "NON_REQUIRED", "")
arcpy.AddField_management(mw_Junction_shp, Age, "FLOAT", "", "", "", "", "NULLABLE", "NON_REQUIRED", "")
arcpy.AddField_management(mw_Junction_shp, FFR6, "FLOAT", "", "", "", "", "NULLABLE", "NON_REQUIRED", "")
arcpy.AddField_management(mw_Junction_shp, FFR9, "FLOAT", "", "", "", "", "NULLABLE", "NON_REQUIRED", "")
# Process: Junctions - Join Fields and Calculate them
### - find out why ### arcpy.JoinField_management(mw_Junction_shp, "MUID", RES_Pressure_Qp, "MUID", "Max;Min")

#SQL update
#  SELECT RES_Pressure_SS_Qd.MUID, RES_Pressure_SS_Qp.Min AS PminQp, RES_Pressure_SS_Qp.Max AS PmaxQp, RES_Pressure_SS_Qd.Min AS PminQd, RES_Pressure_SS_Qd.Max AS PmaxQd, [RES_Quality_Age_SS Qp].Max AS Age, RES_FireFlow_6ls_SS.Min AS FireFlow6, RES_FireFlow_9ls_SS.Min AS FireFlow9
#FROM (((RES_Pressure_SS_Qd INNER JOIN RES_Pressure_SS_Qp ON RES_Pressure_SS_Qd.MUID = RES_Pressure_SS_Qp.MUID) INNER JOIN [RES_Quality_Age_SS Qp] ON RES_Pressure_SS_Qd.MUID = [RES_Quality_Age_SS Qp].MUID) INNER JOIN RES_FireFlow_6ls_SS ON RES_Pressure_SS_Qd.MUID = RES_FireFlow_6ls_SS.MUID) INNER JOIN RES_FireFlow_9ls_SS ON RES_Pressure_SS_Qd.MUID = RES_FireFlow_9ls_SS.MUID;
