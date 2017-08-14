<cfcomponent displayname="form">

	<cffunction name="init" output="false" access="public" returntype="form" hint="I am the form builder object and I build dynamic forms">
		<cfreturn this/>
	</cffunction>
	
	<cffunction name="getFormOpener" output="false" access="private" returntype="string" hint="I reutrn the starting portion of the form HTML element">
		<cfargument name="name" type="string" required="true"/>
		<cfargument name="action" type="string" required="true"/>
		<cfargument name="method" type="string" required="true"/>
		<cfargument name="enctype" type="string" required="false"/>
		<cfargument name="onClick" type="string" required="false"/>
		<cfset var h = ""/>
		<cfsavecontent variable="h">
			<cfoutput>
				<form name="#arguments.name#" action="#arguments.action#" method="#arguments.method#" 
					<cfif Len(arguments.enctype)>enctype="#arguments.enctype#"</cfif> 
					<cfif Len(arguments.onClick)>onClick="#arguments.onClick#"</cfif>>
			</cfoutput>
		</cfsavecontent>
		<cfreturn h/>
	</cffunction>
	
	<cffunction name="getFormClosing" output="false" access="private" returntype="string" hint="I return the ending portion of the form HTML element">
		<cfreturn "</form>"/>
	</cffunction>
	
	<cffunction name="renderForm" output="false" access="private" returntype="string" hint="I render the form">
		<cfargument name="formElements" type="array" required="true"/>
		<cfset var h = ""/>
		<cfsavecontent variable="h">
			<cfoutput>
				<cfloop from="1" to="#ArrayLen(arguments.formElements)#" index="frm">
					#arguments.formElements[frm]#
				</cfloop>
			</cfoutput>
		</cfsavecontent>
		<cfreturn h/>
	</cffunction>
	
	<cffunction name="getHiddenElement" output="false" access="private" returntype="string" hint="I return hidden variable form elements">
		<cfargument name="hiddenName" type="string" required="true"/>
		<cfargument name="hiddenValue" type="string" required="true"/>
		<cfset var h = ""/>
		<cfsavecontent variable="h">
			<cfoutput><input type="hidden" name="#arguments.hiddenName#" value="#arguments.hiddenValue#"/></cfoutput>
		</cfsavecontent>
		<cfreturn h/>
	</cffunction>
	
	<cffunction name="generateCssForm" output="false" access="public" returntype="string" hint="I generate the form and return the finished Product">
		<cfargument name="formStruct" type="struct" required="true"/>
		<cfset var frmString = ArrayNew(1)>
		<cfset var hiddenName = ""/>
		<cfset var hiddenValue = ""/>
		<cfset var hElementLabel = ""/>
		<cfset var hElementName = ""/>
		<cfset var hElementRequired = false/>
		<cfset var hElementReqMessage = ""/>
		<cfset var hElementValue = ""/>
		<cfset var hElementShowHorizontal = false/>
		<cfset var hdn = ""/>
		<cfset var elem = ""/>
		<cfset var item = ""/>
		
		<cfif StructKeyExists(arguments.formStruct,"enctype")>
			<cfset hFormEncType = arguments.formStruct.enctype/>
		<cfelse>
			<cfset hFormEncType = ""/>
		</cfif>
		<cfif StructKeyExists(arguments.formStruct,"OnClick")>
			<cfset hFormOnClick = arguments.formStruct.onClick/>
		<cfelse>
			<cfset hFormOnClick = ""/>
		</cfif>
		<!--- Get the form open tag --->
		<cfset frmString[1] = getFormOpener(arguments.formStruct.name,arguments.formStruct.action,arguments.formStruct.method,
								hFormEncType,hFormOnClick)/>
		
		<!--- Load up the hidden variables, only if they are present --->
		<cfif StructKeyExists(arguments.formStruct,"hiddenVars") and ArrayLen(arguments.formStruct.hiddenVars)>
			<cfloop from="1" to="#ArrayLen(arguments.formStruct.hiddenVars)#" index="hdn">
				<cfswitch expression="#ListLen(arguments.formStruct.hiddenVars[hdn],"|")#">
					<cfcase value="1">
						<cfset hiddenName = ListGetAt(arguments.formStruct.hiddenVars[hdn],1,"|")/>
						<cfset hiddenValue = ""/>
						<cfset frmString[ArrayLen(frmString)+1] = getHiddenElement(hiddenName,hiddenValue)/>
					</cfcase>
					<cfcase value="2">
						<cfset hiddenName = ListGetAt(arguments.formStruct.hiddenVars[hdn],1,"|")/>
						<cfset hiddenValue = ListGetAt(arguments.formStruct.hiddenVars[hdn],2,"|")/>
						<cfset frmString[ArrayLen(frmString)+1] = getHiddenElement(hiddenName,hiddenValue)/>
					</cfcase>
					<cfdefaultcase>
						<cfthrow message="Hidden variables only support the name and the value attributes.">
					</cfdefaultcase>
				</cfswitch>
			</cfloop>
		</cfif>
		
		<!--- Now load in all the CSS form elements --->
		<cfif ArrayLen(arguments.formStruct.formElements)>
			<!--- 
				Loop through the form elements and save the type, name, value, class, id, size, and maxlength.  Then when that information is done
				push the form attributes to the form element generator.
			 --->
			<cfloop from="1" to="#ArrayLen(arguments.formStruct.formElements)#" index="elem">
				<!--- Refresh the hold variables for each form element --->
				<cfset hElementLabel = ""/>
				<cfset hElementName = ""/>
				<cfset hElementValue = ""/>
				<cfset hElementRequired = false/>
				<cfset hElementShowHorizontal = false/>
				<cfset hElementReqMessage = ""/>
				
				<cfloop list="#arguments.formStruct.formElements[elem]#" index="item" delimiters="|">
					<cfswitch expression="#GetToken(item,1,':')#">
						<cfcase value="type">
							<cfset hElementType = #GetToken(item,2,':')#/>
						</cfcase>
						<cfcase value="required">
							<cfif #GetToken(item,2,':')# eq 'true'>
								<cfset hElementRequired = true/>
							<cfelse>
								<cfset hElementRequired = false/>
							</cfif>							
						</cfcase>
						<cfcase value="name">
							<cfset hElementName = #GetToken(item,2,':')#/>
						</cfcase>
						<cfcase value="label">
							<cfset hElementLabel = #GetToken(item,2,':')#/>
						</cfcase>
						<cfcase value="reqMessage">
							<cfset hElementReqMessage = #GetToken(item,2,':')#/>
						</cfcase>
						<cfcase value="value">
							<cfset hElementValue = #GetToken(item,2,':')#/>
						</cfcase>
						<cfcase value="showHorizontal">
							<cfif #GetToken(item,2,':')# eq ''>
								<cfset hElementShowHorizontal = false/>
							<cfelse>
								<cfset hElementShowHorizontal = #GetToken(item,2,':')#/>
							</cfif>
						</cfcase>
					</cfswitch>
				</cfloop>
				<cfif NOT StructKeyExists(arguments.formStruct,"selectQry")>
					<cfset arguments.formStruct.selectQry = QueryNew("temp")>
				</cfif>
				<cfset frmString[ArrayLen(frmString)+1] = getCssFormElement(hElementType,
																			hElementLabel,
																			hElementName,
																			arguments.formStruct.formElements[elem],
																			hElementRequired,
																			hElementReqMessage,
																			hElementShowHorizontal,
																			arguments.formStruct.selectQry
																			)/>
			</cfloop>
			<cfset frmString[ArrayLen(frmString)+1] = getFormClosing()/>
			<cfset frmString[ArrayLen(frmString)+1] = buildSpryWidgets(arguments.formStruct.formElements)>
		<cfelse>
			<cfthrow message="You have to send in form elements.">
		</cfif>
		<cfreturn renderForm(frmString)/>
	</cffunction>
	
	<cffunction name="getCorrectWidget" output="false" access="private" returntype="string" hint="I find the correct wdiget">
		<cfargument name="htype" type="string" required="true"/>
		<cfswitch expression="#arguments.htype#">
			<cfcase value="text"><cfreturn "new Spry.Widget.ValidationTextField"/></cfcase>
			<cfcase value="textarea"><cfreturn "new Spry.Widget.ValidationTextarea"/></cfcase>
			<cfcase value="select"><cfreturn "new Spry.Widget.ValidationSelect"/></cfcase>
			<cfcase value="checkbox"><cfreturn "new Spry.Widget.ValidationCheckbox"/></cfcase>
			<cfcase value="password"><cfreturn "new Spry.Widget.ValidationTextField"/></cfcase>
		</cfswitch>
	</cffunction>
	
	<cffunction name="buildSpryWidgets" output="false" access="private" returntype="string" hint="I build the javascript spry widget declarations.">
		<cfargument name="elementArray" type="array" required="true"/>
		<cfset var arr = ""/>
		<cfset var h = ""/>
		<cfset var j = ""/>
		<cfset var item = "">
		<cfset var hElementType = ""/>
		<cfset var hElementName = ""/>
		<cfset var hElementRequired = false/>
		<cfsilent>
			<cfloop from="1" to="#ArrayLen(arguments.elementArray)#" index="arr">
				<cfset hElementType = ""/>
				<cfset hElementName = ""/>
				<cfset hElementRequired = false/>
					<cfloop list="#arguments.elementArray[arr]#" index="item" delimiters="|">
						<cfswitch expression="#GetToken(item,1,':')#">
							<cfcase value="type">
								<cfset hElementType = #GetToken(item,2,':')#/>
							</cfcase>
							<cfcase value="name">
								<cfset hElementName = #GetToken(item,2,':')#/>
							</cfcase>
							<cfcase value="required">
								<cfset hElementRequired = #GetToken(item,2,':')#/>
							</cfcase>
						</cfswitch>
					</cfloop>
				<cfif Len(hElementType) and Len(hElementName) and hElementRequired>
					<cfset j = j & "#Chr(13)#var #hElementName# = #getCorrectWidget(hElementType)#(""#hElementName#Field"");"/>
				</cfif>
			</cfloop>
		</cfsilent>
		<cfsavecontent variable="h">
			<script type="text/javascript">
				<cfoutput>#j#</cfoutput>
			</script>
		</cfsavecontent>
		<cfreturn h/>
	</cffunction>
	
	<cffunction name="getCssFormElement" output="false" access="private" returntype="string" hint="I delegate what method will render the form element.">
		<cfargument name="elementType" type="string" required="true"/>
		<cfargument name="elementLabel" type="string" required="true"/>
		<cfargument name="elementName" type="string" required="false"/>
		<cfargument name="elementList" type="string" required="true"/>
		<cfargument name="elementRequired" type="boolean" required="false"/>
		<cfargument name="elementReqMessage" type="string" required="false" default=""/>
		<cfargument name="elementShowHorizontal" type="string" required="false" default=""/>
		<cfargument name="elementSelectQry" type="query" required="false"/>
		
		<cfswitch expression="#arguments.elementType#">
			<cfcase value="textarea">
				<cfreturn getCssTextareaElement(arguments.elementList,
											arguments.elementLabel,
											arguments.elementName,
											arguments.elementRequired,
											arguments.elementReqMessage,
											arguments.elementShowHorizontal
											)/>
			</cfcase>
			<cfcase value="select">
				<cfreturn getCssSelectElement(arguments.elementList,
											arguments.elementLabel,
											arguments.elementName,
											arguments.elementSelectQry,
											arguments.elementRequired,
											arguments.elementReqMessage,
											arguments.elementShowHorizontal
											)/>
			</cfcase>
			<cfcase value="submit">
				<cfreturn getCssSubmitElement(arguments.elementList)/>
			</cfcase>
			<cfdefaultcase>
				<cfreturn getCssBasicElement(arguments.elementList,
											arguments.elementLabel,
											arguments.elementName,
											arguments.elementRequired,
											arguments.elementReqMessage,
											arguments.elementShowHorizontal
											)/>
			</cfdefaultcase>
		</cfswitch>
	</cffunction>
	
	<cffunction name="getCssBasicElement" output="false" access="private" returntype="string" hint="I build the text form element">
		<cfargument name="elementList" type="string" required="true"/>
		<cfargument name="elementLabel" type="string" required="true"/>
		<cfargument name="elementName" type="string" required="true"/>
		<cfargument name="elementRequired" type="boolean" required="false" default=""/>
		<cfargument name="elementReqMessage" type="string" required="false" default=""/>
		<cfargument name="elementShowHorizontal" type="string" required="false" default=""/>
		<cfset var h = ""/>
		<cfsavecontent variable="h">
			<cfsetting enablecfoutputonly="true">
			<cfoutput>
				<div class="<cfif arguments.elementShowHorizontal>horizontal<cfelse></cfif>row">
					<div class="lcell">#arguments.elementLabel#</div>
					<div class="rcell">
						<cfif arguments.elementRequired>
							<span id="#arguments.elementName#Field">
						</cfif>
						<input <cfprocessingdirective suppresswhitespace="true">
									<cfloop list="#arguments.elementList#" index="item" delimiters="|"> 
										<cfif #GetToken(item,1,':')# eq 'id'><cfelseif #GetToken(item,1,':')# eq 'name'>
											#GetToken(item,1,':')#="#GetToken(item,2,':')#"	id="#GetToken(item,2,':')#Field"	
										<cfelse>
											#GetToken(item,1,':')#="#GetToken(item,2,':')#"									
										</cfif>
									</cfloop> /></cfprocessingdirective>
							<span class="textfieldRequiredMsg">#arguments.elementReqMessage#</span>
						</span>
					</div>
				</div>
			</cfoutput>
			<cfsetting enablecfoutputonly="false">			
		</cfsavecontent>
		<cfreturn h/>
	</cffunction>
	
	<cffunction name="getCssTextareaElement" output="false" access="private" returntype="string" hint="I build the textarea form element">
		<cfargument name="elementList" type="string" required="true"/>
		<cfargument name="elementLabel" type="string" required="true"/>
		<cfargument name="elementName" type="string" required="true"/>
		<cfargument name="elementRequired" type="string" required="false" default=""/>
		<cfargument name="elementReqMessage" type="string" required="false" default=""/>
		<cfargument name="elementShowHorizontal" type="string" required="false" default=""/>
		<cfset var h = ""/>
		<cfsavecontent variable="h">
			<cfsetting enablecfoutputonly="true">
			<cfoutput>
				<div class="<cfif arguments.elementShowHorizontal>horizontal<cfelse></cfif>row">
					<div class="lcell">#arguments.elementLabel#</div>
					<div class="rcell">
						<cfif arguments.elementRequired>
							<span id="#arguments.elementName#Field">
						</cfif>
						<textarea <cfprocessingdirective suppresswhitespace="true">
									<cfloop list="#arguments.elementList#" index="item" delimiters="|"> 
											<cfif #GetToken(item,1,':')# eq 'id'>
											<cfelseif #GetToken(item,1,':')# eq 'name'>
												#GetToken(item,1,':')#="#GetToken(item,2,':')#"	id="#GetToken(item,2,':')#Field"		
											<cfelse>
												#GetToken(item,1,':')#="#GetToken(item,2,':')#"						
											</cfif>
									  </cfloop> </cfprocessingdirective> >
							#arguments.elementValue#
						</textarea>
						<span class="textareaRequiredMsg">#arguments.elementReqMessage#</span>
						</span>
					</div>
				</div>
			</cfoutput>
			<cfsetting enablecfoutputonly="false">			
		</cfsavecontent>
		<cfreturn h/>
	</cffunction>
	
	<cffunction name="getCssSelectElement" output="false" access="private" returntype="string" hint="I build the textarea form element">
		<cfargument name="elementList" type="string" required="true"/>
		<cfargument name="elementLabel" type="string" required="true"/>
		<cfargument name="elementName" type="string" required="true"/>
		<cfargument name="elementSelectQry" type="string" required="false" default=""/>
		<cfargument name="elementRequired" type="string" required="false" default=""/>
		<cfargument name="elementReqMessage" type="string" required="false" default=""/>
		<cfargument name="elementShowHorizontal" type="string" required="false" default=""/>
		<cfset var h = ""/>
		<cfsavecontent variable="h">
			<cfsetting enablecfoutputonly="true">
			<cfoutput>
				<div class="<cfif arguments.elementShowHorizontal>horizontal<cfelse></cfif>row">
					<div class="lcell">#arguments.elementLabel#</div>
					<div class="rcell">
						<cfif arguments.elementRequired>
							<span id="#arguments.elementName#Field">
						</cfif>
						<select <cfprocessingdirective suppresswhitespace="true">
									<cfloop list="#arguments.elementList#" index="item" delimiters="|"> 
										<cfif #GetToken(item,1,':')# eq 'id'>
										<cfelseif #GetToken(item,1,':')# eq 'name'>
											#GetToken(item,1,':')#="#GetToken(item,2,':')#"	id="#GetToken(item,2,':')#Field"
										<cfelse>
											#GetToken(item,1,':')#="#GetToken(item,2,':')#"
										</cfif>
									</cfloop></cfprocessingdirective>>
							<cfloop query="arguments.elementSelectQry">
								<option value="#optionId#" <cfif #optionId# eq #arguments.elementValue#>selected</cfif>>#optionValue#
							</cfloop>
						</select>
						<span class="selectRequiredMsg">#arguments.elementReqMessage#</span>
						</span>
					</div>
				</div>
			</cfoutput>
			<cfsetting enablecfoutputonly="false">
		</cfsavecontent>
		<cfreturn h/>
	</cffunction>
	
	
	<cffunction name="getCssSubmitElement" output="false" access="private" returntype="string" hint="I build the text form element">
		<cfargument name="elementList" type="string" required="false" default="Submit"/>
		<cfset var h = ""/>
		<cfsavecontent variable="h">
			<cfoutput>
				<input type="submit" <cfprocessingdirective suppresswhitespace="true">
										<cfloop list="#arguments.elementList#" index="item" delimiters="|">
											<cfif #GetToken(item,1,':')# eq 'type'><cfelse>
												#GetToken(item,1,':')#="#GetToken(item,2,':')#"	
											</cfif>
										</cfloop></cfprocessingdirective>>
				
			</cfoutput>
		</cfsavecontent>
		<cfreturn h/>
	</cffunction>

</cfcomponent>