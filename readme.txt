LICENSE 

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at
    http://www.apache.org/licenses/LICENSE-2.0
Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
   

==========================================================
Syntax/Example
==========================================================
*********************************************************************
You have to import the spry assets that you will need for the form.  
Supported Form HTML attributes: 
	Name, Action, Method, Enctype, OnClick
The structure keys (elementClass and elementId) are used for each of the input elements and not the form tag itself.  It's just a global class for text and textarea elements.
For elements that need a name and value, they will throw an error if they are left out.  Blank values can just remain like this "value:".
Please forgive me for the readme file.
*********************************************************************


<cfhtmlhead text="
	<script src='SpryAssets/SpryValidationTextField.js' type='text/javascript'></script> 
	<link href='SpryAssets/SpryValidationTextField.css' rel='stylesheet' type='text/css' /> 			
">
<cfset formulator = createObject("component","objects.form").init()>
<cfset newFrm = StructNew()/>
<cfset newFrm.name = "frm"/>
<cfset newFrm.action = "#cgi.SCRIPT_NAME#"/>
<cfset newFrm.method = "post"/>
<cfset newFrm.elementClass = "">
<cfset newFrm.elementId = "">
<cfset newFrm.formElements = ArrayNew(1)/>
<!--- 
	Form Elements are in this order:
		Element Label, Element Type, Element Name, Element Value, Element Value Label, Element Size, Element Max Length
 --->
<cfset newFrm.formElements[1] = "label:Username|type:text|name:jusername|value:|valueLabel:|size:30|maxLength:30|required:true|reqMessage:Username is required"/>
<cfset newFrm.formElements[2] = "label:Password|type:password|name:jpassword|value:|valueLabel:|size:30|maxLength:30|required:true|reqMessage:Password is required"/>
<cfset newFrm.formElements[3] = "label:|type:submit|value:Log In"/>


<cfoutput>#formulator.generateCssForm(variables.newFrm)#</cfoutput>