require File.dirname(__FILE__) + "/extensions/Server.rb"
require $ifc_path + '/IfcTypeClasses_IFC2X3_TC1.rb'
load_schema_and_extensions
#Settings of this script
$bim = $ifc_file_name
$export_dir_path = $ifc_path + "/xxx/#{$username}/#{$bim}"
$cypher_script_file_name = "#{$bim.sub(".ifc","")}_import_commands.txt"
$export_url = "xxx/#{$username}/#{$bim}"
save_zip_file = false
export_csv = true                                                                                                                                                                                                                           

$ignore_classes= ["IFC","IfcGeometricSet","IfcCompositeCurve","IfcArbitraryClosedProfileDef","IfcCurveStyle",
"IfcCircleProfileDef","IfcArbitraryOpenProfileDef","IfcDraughtingPreDefinedCurveFont",
"IfcProfileDef","IfcAsymmetricIShapeProfileDef","IfcFaceBasedSurfaceModel","IfcFaceBound","IfcRectangleProfileDef",
"IfcIShapeProfileDef","IfcFillAreaStyle","IfcCartesianPoint","IfcLocalPlacement","IfcDirection","IfcSurfaceOfLinearExtrusion",
"IfcFillAreaStyleHatching","IfcPlane","IfcCurveBoundedPlane","IfcCompositeCurveSegment","IfcTrimmedCurve","IfcCircle","IfcPolyLoop",
"IfcColourRgb","IfcStyledItem","IfcFaceOuterBound","IfcFace","IfcFacetedBrep","IfcConnectedFaceSet","IfcClosedShell",
"IfcSurfaceStyleRendering","IfcOpenShell","IfcExtrudedAreaSolid","IfcCartesianTransformationOperator3D","IfcAxis2Placement3D",
"IfcAxis2Placement2D","IfcPolyline"]

ignore_relatioships=["ownerHistory"]

puts "BIM Model: #{$bim }</br>"
puts "Start the IFC2Neo4j converting process ...<br>"
puts "Settings:<br>"
puts "Ignored classes:" + $ignore_classes.to_s + "<hr>"
create_if_missing $export_dir_path
input_filenames = []
$export_csv_file = File.new("#{$export_dir_path}/#{$cypher_script_file_name}", 'w') 
$export_csv_file.puts "// BIM Model: #{$bim}</br>"
 
classes_list=Server.classes_list($bim)
classes_list.each { |classname,count_of_objects|
class_vars= {}
next if $ignore_classes.include?(classname)
class_obj = Kernel.const_get(classname.to_s.upcase.strip)
$output_format = "to_csv"
report_columns = "Model:'#{$bim}'|label:'#{classname}'|IFCID:line_id"
class_obj.ancestors.reverse.each { |cl_parent|
    report_columns += $report_cols_by_class[cl_parent.to_s.upcase.strip] if $report_cols_by_class[cl_parent.to_s.upcase.strip]
  if  defined? cl_parent::ClassVars
      class_vars = class_vars.merge(cl_parent::ClassVars)
   end 
}
 
$export_csv_file.puts "load csv with headers from '#{$server_ip}/#{$export_url}/#{classname}.xls' as line FIELDTERMINATOR '  '
create (u:#{classname} {"

columns = []
report_columns.split('|').each do |i|
    next if i == ""
    if i.split(':').size > 1
        xx=i.split(':')[0]
        i=i.split(':')[1]
    else
        xx=i
    end
    columns << xx.strip + ":" + "line." + xx.strip 
end
$export_csv_file.puts  columns.join(",\n")
$export_csv_file.puts "});\n\n\n"
 
# Start the CSV export
if export_csv
  read_ifc_file($ifc_file_name)
  $old_stdout = $stdout.dup  
  if not  File.exists?("#{$export_dir_path}/#{classname}.xls")
     $stdout = File.new("#{$export_dir_path}/#{classname}.xls", 'w')    
     class_obj.list report_columns, false 
  end  
input_filenames << "#{classname}.xls"
$stdout = $old_stdout
puts "IFC -> CSV for the class #{classname}: Done\</br>"
$row_ID = nil
end
}
$export_csv_file.close
 
#simple_attributes = IfcTypeClasses.constants.select {|c| c.to_s if IfcTypeClasses.const_get(c).is_a? Class}
simple_attributes << ["IfcDateTimeSelect","IfcActorSelect","IfcAppliedValueSelect","IfcConditionCriterionSelect",
  "IfcClassificationNotationSelect","IfcCsgSelect","IfcCurveFontOrScaledCurveFontSelect",
  "IfcSizeSelect","IfcCurveStyleFontSelect","IfcDefinedSymbolSelect","IfcFillStyleSelect",
  "IfcHatchLineDistanceSelect","IfcFillAreaStyleTileShapeSelect","IfcGeometricSetSelect",
  "IfcLightDistributionDataSourceSelect","IfcMetricValueSelect","IfcPresentationStyleSelect",
  "IfcObjectReferenceSelect","IfcDocumentSelect","IfcLibrarySelect","IfcMaterialSelect","IfcOrientationSelect",
  "IfcSurfaceStyleElementSelect","IfcSpecularHighlightSelect","IfcSymbolStyleSelect","IfcCharacterStyleSelect",
  "IfcTextStyleSelect","IfcTextFontSelect"]

#Start with generation relationships script
$relation_ID= 0
 
relationtemplate= "MATCH (n:XXRelationClass {Model:\"#{$bim}\"})
UNWIND split( replace( replace(n.xxRelationAtt,\"(\",\"\"),\")\",\"\"),\",\") as o
MERGE (XXXRelationAtt {Model:\"#{$bim}\", IFCID: replace(o,\"#\",\"\")})
MERGE (p {Model:\"#{$bim}\" ,IFCID: replace( n.XXRelationTargetAtt,\"#\",\"\")})
MERGE (XXXRelationAtt)-[XXRelationName]->(p);\n\n"
 
$relation_script_file = File.new("#{$export_dir_path}/#{$cypher_script_file_name}", 'a') 
relations_data = { 
 "IfcRelAggregates" =>  { "relatedAtt" => "relatedObjects", "relatingAtt" => "relatingObject", "relationName" => ":Decomposes"},
 "IfcRelAssignsTasks" =>  { "relatedAtt" => "relatedObjects", "relatingAtt" => "relatingControl", "relationName" => ":HasAssignments"},
 "IfcRelAssignsToGroup" =>  { "relatedAtt" => "relatedObjects", "relatingAtt" => "relatingGroup", "relationName" => ":HasAssignments"},
 "IfcRelAssignsToActor" => { "relatedAtt" => "relatedObjects", "relatingAtt" => "relatingActor", "relationName" => ":HasAssignments"},
 "IfcRelAssignsToProcess" =>  { "relatedAtt" => "relatedObjects", "relatingAtt" => "relatingProcess", "relationName" => ":HasAssignments"},
 "IfcRelAssociatesClassification" =>  { "relatedAtt" => "relatedObjects", "relatingAtt" => "relatingClassification" , "relationName" => ":HasAssociations"},
 "IfcRelAssociatesMaterial"  =>  { "relatedAtt" => "relatedObjects", "relatingAtt" => "relatingMaterial" ,"relationName" => ":HasAssociations"},
 "IfcRelSpaceBoundary" =>  { "relatedAtt" => "relatedBuildingElement", "relatingAtt" => "relatingSpace",  "relationName" => ":BoundedBy" },
 "IfcRelDefinesByProperties" =>  { "relatedAtt" => "relatedObjects", "relatingAtt" => "relatingPropertyDefinition",  "relationName" => ":IsDefinedByProperties"},
 "IfcRelDefinesByType" =>  { "relatedAtt" => "relatedObjects", "relatingAtt" => "relatingType",  "relationName" => ":IsDefinedByType"},
 "IfcRelFillsElement" =>  { "relatedAtt" => "relatedBuildingElement", "relatingAtt" => "relatingOpeningElement",  "relationName" => ":FillsVoids"},
 "IfcRelVoidsElement" =>  { "relatedAtt" => "relatedOpeningElement", "relatingAtt" => "relatingBuildingElement",  "relationName" => ":VoidsElements"},
 "IfcRelCoversSpaces" =>  { "relatedAtt" => "relatedCoverings", "relatingAtt" => "relatedSpace",  "relationName" => ":HasCoverings"},
 "IfcRelConnectsElements" =>  { "relatedAtt" => "relatedElement", "relatingAtt" => "relatingElement",  "relationName" => ":ConnectedFrom"},
 "IfcRelConnectsPathElements" => { "relatedAtt" => "relatedElement", "relatingAtt" => "relatingElement",  "relationName" => ":RelConnectsPathElements"},
 "IfcRelConnectsPorts" =>  { "relatedAtt" => "relatedPort", "relatingAtt" => "relatingPort",  "relationName" => ":RelConnectsPorts"},
 "IfcRelConnectsPortToElement" =>  { "relatedAtt" => "relatedElement", "relatingAtt" => "relatingPort",  "relationName" => ":RelConnectsPortToElement"},
 "IfcRelContainedInSpatialStructure" =>  { "relatedAtt" => "relatedElements ", "relatingAtt" => "relatingStructure",  "relationName" => ":ContainsElements"},
 "IfcRelCoversBldgElements" =>  { "relatedAtt" => "relatedCoverings", "relatingAtt" => "relatingBuildingElement",  "relationName" => ":RelCoversBldgElements"},
 "IfcRelNests" =>  { "relatedAtt" => "relatedObjects", "relatingAtt" => "relatingObject",  "relationName" => ":RelNests"},
 "IfcRelSequence" =>  { "relatedAtt" => "relatedProcess", "relatingAtt" => "relatingProcess",  "relationName" => ":RelSequence"},
 "IfcRelServicesBuildings" =>  { "relatedAtt" => "relatedBuildings", "relatingAtt" => "relatingSystem",  "relationName" => ":RelServicesBuildings"}
}
#TODOs:
#IfcRelAssociatesDocument --> relatingDocument
#IfcRelAssociatesLibrary --> relatingLibrary
#IfcRelConnectsStructuralElement --> relatingElement|relatedStructuralMember
#IfcRelProjectsElement --> relatingElement|relatedFeatureElement    
#IfcRelReferencedInSpatialStructure --> relatedElements|relatingStructure
#IfcRelConnectsWithRealizingElements --> realizingElements|connectionType
# …

relations_data.each { |rel_class, rel_atts|
command = relationtemplate.gsub("XXRelationClass",rel_class).gsub("XXXRelationAtt",rel_atts["relatedAtt"]).gsub("xxRelationAtt",rel_atts["relatedAtt"]).sub("XXRelationName",rel_atts["relationName"]).sub("XXRelationTargetAtt",rel_atts["relatingAtt"])
$relation_script_file.puts command
}
 
classes_list=Server.classes_list($bim)
classes_list.each { |classname,count_of_objects|
next if $ignore_classes.include?(classname)
next if classname == "Ifc"
class_vars= {}
class_obj = Kernel.const_get(classname.to_s.upcase.strip)
class_obj.ancestors.reverse.each { |cl_parent|
  class_vars = class_vars.merge(cl_parent::ClassVars) if  defined? cl_parent::ClassVars
}

class_vars.each { |k,v|
att_name= v.sub("OPTIONAL ","")
if $ifcClassesNames.values.include?(att_name)
    $relation_script_file.puts  "//" + classname + "." + k.to_s + ": " +  att_name + "</br>\n"
    command = "match(o:#{classname}  {Model:\"#{$bim}\"})\n"
    command += "MERGE (att {Model:\"#{$bim}\" , IFCID: replace(o.#{k},\"#\",\"\")})\n"
    command +=  "MERGE (o)-[:#{k}]->(att);\n\n"
    $relation_script_file.puts command if not ignore_relatioships.include?(k) and k.to_s != "ownerHistory"
else
    if not simple_attributes.to_s.include?(att_name.split(" ")[-1].strip.gsub(" ",""))
        if att_name.include?("IfcRel") and att_name.include?(" FOR") and not att_name.include?("IfcRelAssociates")
          xxRelationClass  = "IfcRel" + att_name[/#{"IfcRel"}(.*?)#{" FOR"}/m, 1].gsub(" ","")
          #Igonre the Relationship if we already added it before relations_data
          next if relations_data[xxRelationClass] != nil
          #Ignore the ownerHistroy relationship
          next if k.to_s == "ownerHistory"
          xxRelationAtt = att_name.split(" ")[-1].strip.gsub(" ","").to_s
          xxRelationClass_obj = Kernel.const_get(xxRelationClass.to_s.upcase.strip)
          if xxRelationClass_obj::ABSTRACT
          else
            target_att_name = att_name.split(" ")[-1]
            $report_cols_by_class[xxRelationClass.upcase].sub("|" + target_att_name[0, 1].downcase + target_att_name[1..-1],"")
            xxRelationTargetAtt = "UNKNOWN"
            if  $report_cols_by_class[xxRelationClass.upcase].split("|").size  == 2
                xxRelationTargetAtt = $report_cols_by_class[xxRelationClass.upcase].sub("|" ,"")
            else
              #  xxRelationTargetAtt = $report_cols_by_class[xxRelationClass.upcase].sub("|" + xxRelationAtt[0, 1].downcase + xxRelationAtt[1..-1] ,"").split("|")[0]
            end
            next if $ignore_classes.include?(xxRelationClass)
            command = relationtemplate.gsub("XXRelationClass",xxRelationClass).gsub("XXXRelationAtt",xxRelationAtt).gsub("xxRelationAtt", xxRelationAtt[0, 1].downcase + xxRelationAtt[1..-1] ).sub("XXRelationName", ":" + k.to_s).sub("XXRelationTargetAtt",xxRelationTargetAtt)
          end
        end
        $relation_ID += 1
        if not att_name.split(" ")[-1].to_s.include?("BOOLEAN") and not att_name.split(" ")[-1].to_s.include?("INTEGER")  and not att_name.split(" ")[-1].to_s.include?("Enum")
            puts $relation_script_file.puts  "//TODO#{$relation_ID}: " + classname + "." + k.to_s + ": " +  att_name + "</br>\n"
            puts "</br>//TODO#{$relation_ID}:" + classname + "." + k.to_s + ": " +  att_name + " >>>> #{att_name.split(" ")[-1]}</br>"
        end
    end
end
}
}
$relation_script_file.close
puts "<hr>"
puts "<a href='/#{$export_url}/#{$bim.sub(".ifc","")}_import_commands.txt'> IFC--> Neo4J</a><hr>"
