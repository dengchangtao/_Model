# -*- coding: utf-8 -*-
# ---------------------------------------------------------------------------
# 3_Centroids.py
# Created on: 2015-02-23 16:19:12.00000
#   (generated by ArcGIS/ModelBuilder)
# Description: 
# ---------------------------------------------------------------------------
# Import arcpy module
import os
import arcpy

# http://www.xtoolspro.com/default.asp

# Local variables:
Model_mdb = "C:\\_Model\\Output\\SHP_WGS"		#Model path
Output = "C:\\_Model\\SHP_WGS"					#Output path
# Other variables should be filled automatically

toolbox_XTools = "C:\Program Files (x86)\DataEast\XToolsPro 9.0\Toolbox\XTOOLS PRO.TBX"
arcpy.ImportToolbox(toolbox_XTools)
print "XTools Toolbox imported..";

mw_Pump_shp = Model_mdb+"\\mw_Pump.shp"
mw_Pump_pt_shp = Output+"\\mw_Pump_pt.shp"

mw_Valve_shp = Model_mdb+"\\mw_Valve.shp"
mw_Valve_pt_shp = Output+"\\mw_Valve_pt.shp"

# Process: Convert Features to Centroids
arcpy.gp.toolbox = "c:/program files (x86)/DataEast/xtoolspro 9.0/Toolbox/XTools Pro.tbx";
# Warning: the toolbox c:/program files (x86)/DataEast/xtoolspro 9.0/Toolbox/XTools Pro.tbx DOES NOT have an alias. 
# Please assign this toolbox an alias to avoid tool name collisions
# And replace arcpy.gp.XToolsPro_Features2Centroids(...) with arcpy.XToolsPro_Features2Centroids_ALIAS(...)
arcpy.gp.XToolsPro_Features2Centroids(mw_Pump_shp, mw_Pump_pt_shp, "CENTER_POINT")
arcpy.gp.XToolsPro_Features2Centroids(mw_Valve_shp, mw_Valve_pt_shp, "CENTER_POINT")

#arcpy.ET_GPPolylineToPoints(Model_mdb+"\\mw_Valve.shp", Output+"\\mw_Valve_pt.shp", "Middle", True)
print "Done";