# IFC-to-Neoj4
This repository includes the IFCWebServer scripts to convert IFC models into Neo4j graph database.


# Steps to convert IFC models into Neo4j graph database
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Note: The steps below don't work any more
The uploaded IFC models can be convetred on the IFCWebServer.org only and the graph database will be hosted on the server.
If you are intersted to use the graph databse feature locally please contact me.

++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

1- Install Neo4j locally on your PC/Server

2- Create a free personal account on the IFCWebServer through the link: http://ifcwebserver.org/login.rb?q=register

3- Login & upload your IFC model(s)

4- Go to http://ifcwebserver.org/run_scripts.rb

5- Select the IFC model from the "BIM models" list

6- Select "IFC 2 Graph DB" script from the "scripts" dropdown list & click "Run" button

7- Click on the link "IFC--> Neo4j" at the end of the script output to get the Cypher commands to import and create the Neo4j DB

8- Copy the Cypher commands and run them on your local installed Neo4j server (you can use http://www.lyonwj.com/LazyWebCypher/ to run the Cypher commands in batch mode) 

9- Done
