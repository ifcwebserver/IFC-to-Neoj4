
#IfcRelDefinesByProperties: Export relationships as CSV
if not  File.exists?("#{$export_dir_path}/IsDefinedByProperties.xls")
  $old_stdout = $stdout.dup  
  $stdout = File.new("#{$export_dir_path}/IsDefinedByProperties.xls", 'w') 
  puts "IFCID1\tIFCID2\n"
  xx={}
  IFCRELDEFINESBYPROPERTIES.where("all","o").each { |o|
  o.relatedObjects.sub("(","").sub(")","").gsub(",","").split("#")[1..-1].each { |pp|
  puts o.relatingPropertyDefinition.sub("#","").to_s + "\t" + pp + "\n" if xx[o.relatingPropertyDefinition.sub("#","").to_s] == nil
  }
  xx[o.relatingPropertyDefinition.sub("#","").to_s]=1
  }
  $stdout.close
  $stdout = $old_stdout
   puts "IFC -> CSV for the relation IsDefinedByProperties: Done\</br>"
end

if not  File.exists?("#{$export_dir_path}/IsDecomposedBy.xls")
  #IfcRelAggregates: Export relationships as CSV
  #"IfcRelAggregates" =>  { "relatedAtt" => "relatedObjects", "relatingAtt" => "relatingObject", "relationName" => ":Decomposes"}
  $old_stdout = $stdout.dup
  $stdout = File.new("#{$export_dir_path}/IsDecomposedBy.xls", 'w') 
  puts "IFCID1\tIFCID2\n"
  xx={}
  IFCRELAGGREGATES.where("all","o").each { |o|
  o.relatedObjects.sub("(","").sub(")","").gsub(",","").split("#")[1..-1].each { |pp|
  puts o.relatingObject.sub("#","").to_s + "\t" + pp + "\n" if xx[o.relatingObject.sub("#","").to_s] == nil
  }
  xx[o.relatingObject.sub("#","").to_s]=1
  }
  $stdout.close
  $stdout = $old_stdout
  puts "IFC -> CSV for the relation IsDecomposedBy: Done\</br>"
else
  
end


if not  File.exists?("#{$export_dir_path}/IsGroupedBy.xls")
  #IfcRelAssignsToGroup: Export relationships as CSV
  #"IfcRelAssignsToGroup" =>  { "relatedAtt" => "relatedObjects", "relatingAtt" => "relatingGroup", "relationName" => ":HasAssignments"}
  $old_stdout = $stdout.dup  
  $stdout = File.new("#{$export_dir_path}/IsGroupedBy.xls", 'w') 
  puts "IFCID1\tIFCID2\n"
  xx={}
  IFCRELASSIGNSTOGROUP.where("all","o").each { |o|
  o.relatedObjects.sub("(","").sub(")","").gsub(",","").split("#")[1..-1].each { |pp|
  puts o.relatingGroup.sub("#","").to_s + "\t" + pp + "\n" if xx[o.relatingGroup.sub("#","").to_s] == nil
  }
  xx[o.relatingGroup.sub("#","").to_s]=1
  }
  $stdout.close
  $stdout = $old_stdout
  puts "IFC -> CSV for the relation IsGroupedBy: Done\</br>"
end

if not  File.exists?("#{$export_dir_path}/AssociatedTo.xls")
  #IfcRelAssociatesMaterial: Export relationships as CSV
  #"IfcRelAssociatesMaterial"  =>  { "relatedAtt" => "relatedObjects", "relatingAtt" => "relatingMaterial" ,"relationName" => ":HasAssociations"}
  $old_stdout = $stdout.dup  
  $stdout = File.new("#{$export_dir_path}/AssociatedTo.xls", 'w') 
  puts "IFCID1\tIFCID2\n"
  xx={}
  IFCRELASSOCIATESMATERIAL.where("all","o").each { |o|
  o.relatedObjects.sub("(","").sub(")","").gsub(",","").split("#")[1..-1].each { |pp|
  puts o.relatingMaterial.sub("#","").to_s + "\t" + pp + "\n" if xx[o.relatingMaterial.sub("#","").to_s] == nil
  }
  xx[o.relatingMaterial.sub("#","").to_s]=1
  }
  $stdout.close
  $stdout = $old_stdout
  puts "IFC -> CSV for the relation AssociatedTo: Done\</br>"
end
#IfcRelSpaceBoundary: Export relationships as CSV
#"IfcRelSpaceBoundary" =>  { "relatedAtt" => "relatedBuildingElement", "relatingAtt" => "relatingSpace",  "relationName" => ":BoundedBy" },

if not  File.exists?("#{$export_dir_path}/ProvidesBoundaries.xls")
  $old_stdout = $stdout.dup  
  $stdout = File.new("#{$export_dir_path}/ProvidesBoundaries.xls", 'w') 
  puts "IFCID1\tIFCID2\n"
  xx={}
  IFCRELSPACEBOUNDARY.where("all","o").each { |o|
  o.relatedBuildingElement.sub("(","").sub(")","").gsub(",","").split("#")[1..-1].each { |pp|
  puts o.relatingSpace.sub("#","").to_s + "\t" + pp + "\n" if xx[o.relatingSpace.sub("#","").to_s] == nil
  }
  xx[o.relatingSpace.sub("#","").to_s]=1
  }
  $stdout.close
  $stdout = $old_stdout
   puts "IFC -> CSV for the relation ProvidesBoundaries: Done\</br>"
end

if not  File.exists?("#{$export_dir_path}/IfcRelDefinesByType.xls")
  #IfcRelDefinesByType: Export relationships as CSV
  #"IfcRelDefinesByType" =>  { "relatedAtt" => "relatedObjects", "relatingAtt" => "relatingType",  "relationName" => ":IsDefinedByType"}
  $old_stdout = $stdout.dup  
  $stdout = File.new("#{$export_dir_path}/IfcRelDefinesByType.xls", 'w') 
  puts "IFCID1\tIFCID2\n"
  xx={}
  IFCRELDEFINESBYTYPE.where("all","o").each { |o|
  o.relatedObjects.sub("(","").sub(")","").gsub(",","").split("#")[1..-1].each { |pp|
  puts o.relatingType.sub("#","").to_s + "\t" + pp + "\n" if xx[o.relatingType.sub("#","").to_s] == nil
  }
  xx[o.relatingType.sub("#","").to_s]=1
  }
  $stdout.close
  $stdout = $old_stdout
  puts "IFC -> CSV for the relation IfcRelDefinesByType: Done\</br>"
end

if not  File.exists?("#{$export_dir_path}/FillsVoids.xls")
  #IfcRelFillsElement: Export relationships as CSV
  #"IfcRelFillsElement" =>  { "relatedAtt" => "relatedBuildingElement", "relatingAtt" => "relatingOpeningElement",  "relationName" => ":FillsVoids"},
  $old_stdout = $stdout.dup  
  $stdout = File.new("#{$export_dir_path}/FillsVoids.xls", 'w') 
  puts "IFCID1\tIFCID2\n"
  xx={}
  IFCRELFILLSELEMENT.where("all","o").each { |o|
  o.relatedBuildingElement.sub("(","").sub(")","").gsub(",","").split("#")[1..-1].each { |pp|
  puts o.relatingOpeningElement.sub("#","").to_s + "\t" + pp + "\n" if xx[o.relatingOpeningElement.sub("#","").to_s] == nil
  }
  xx[o.relatingOpeningElement.sub("#","").to_s]=1
  }
  $stdout.close
  $stdout = $old_stdout
  puts "IFC -> CSV for the relation FillsVoids: Done\</br>"
end

if not  File.exists?("#{$export_dir_path}/ConnectedTo.xls")
  #IfcRelConnectsElements: Export relationships as CSV
  #"IfcRelConnectsElements" =>  { "relatedAtt" => "relatedElement", "relatingAtt" => "relatingElement",  "relationName" => ":ConnectedFrom"}
  $old_stdout = $stdout.dup  
  $stdout = File.new("#{$export_dir_path}/ConnectedTo.xls", 'w') 
  puts "IFCID1\tIFCID2\n"
  xx={}
  IFCRELCONNECTSELEMENTS.where("all","o").each { |o|
  o.relatedElement.sub("(","").sub(")","").gsub(",","").split("#")[1..-1].each { |pp|
  puts o.relatingElement.sub("#","").to_s + "\t" + pp + "\n" if xx[o.relatingElement.sub("#","").to_s] == nil
  }
  xx[o.relatingElement.sub("#","").to_s]=1
  }
  $stdout.close
  $stdout = $old_stdout
  puts "IFC -> CSV for the relation ConnectedTo: Done\</br>"
end

if not  File.exists?("#{$export_dir_path}/ContainedInStructure.xls")
  #IfcRelContainedInSpatialStructure: Export relationships as CSV
  #"IfcRelContainedInSpatialStructure" =>  { "relatedAtt" => "relatedElements ", "relatingAtt" => "relatingStructure",  "relationName" => ":ContainsElements"}
  $old_stdout = $stdout.dup  
  $stdout = File.new("#{$export_dir_path}/ContainedInStructure.xls", 'w') 
  puts "IFCID1\tIFCID2\n"
  xx={}
  IFCRELCONTAINEDINSPATIALSTRUCTURE.where("all","o").each { |o|
  o.relatedElements.sub("(","").sub(")","").gsub(",","").split("#")[1..-1].each { |pp|
  puts o.relatingStructure.sub("#","").to_s + "\t" + pp + "\n" if xx[o.relatingStructure.sub("#","").to_s] == nil
  }
  xx[o.relatingStructure.sub("#","").to_s]=1
  }
  $stdout.close
  $stdout = $old_stdout
  puts "IFC -> CSV for the relation ContainedInStructure: Done\</br>"
end

if not  File.exists?("#{$export_dir_path}/IsNestedBy.xls")
  $old_stdout = $stdout.dup  
  $stdout = File.new("#{$export_dir_path}/IsNestedBy.xls", 'w') 
  puts "IFCID1\tIFCID2\n"
  xx={}
  IFCRELNESTS.where("all","o").each { |o|
  o.relatedObjects.sub("(","").sub(")","").gsub(",","").split("#")[1..-1].each { |pp|
  puts o.relatingObject.sub("#","").to_s + "\t" + pp + "\n" if xx[o.relatingObject.sub("#","").to_s] == nil
  }
  xx[o.relatingObject.sub("#","").to_s]=1
  }
  $stdout.close
  $stdout = $old_stdout
   puts "IFC -> CSV for the relation IsNestedBy: Done\</br>"
end
