<%--
 See the NOTICE file distributed with
 this work for additional information regarding copyright ownership.
 Esri Inc. licenses this file to You under the Apache License, Version 2.0
 (the "License"); you may not use this file except in compliance with
 the License.  You may obtain a copy of the License at

     http://www.apache.org/licenses/LICENSE-2.0

 Unless required by applicable law or agreed to in writing, software
 distributed under the License is distributed on an "AS IS" BASIS,
 WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 See the License for the specific language governing permissions and
 limitations under the License.
--%>
<% // loginBody.jsp - Login page (JSF body) %>
<%@ taglib prefix="f" uri="http://java.sun.com/jsf/core" %>
<%@ taglib prefix="h" uri="http://java.sun.com/jsf/html" %>


<div class="">
	<div class="container">
		<div class="row">
			<div class="col-md-6 col-md-offset-3">
				<div class="user-login bwhite">
					<h1>Accedi ai Servizi</h1>
					<p>Effettua il login inserendo le tue credenziali</p>


					<div class="login">
						
						
							
							
						
						<h:form id="frmLogin" styleClass="fixedWidth">
<h:inputHidden value="#{LoginController.prepareView}"/>

							<fieldset>
																											<div class="top20">
											<div class="bottom5 left12 bold">
												<label id="username-lbl" for="username" class="required">
	Nome utente<span class="star">&nbsp;*</span></label>
											</div>
											<div class="input-group full-width">
											<h:inputText id="userN" size="30" maxlength="128" styleClass="form-controlCustomLogin validate-username required" value="#{LoginController.credentials.username}"/>
																						</div>
										</div>
																																				<div class="top20">
											<div class="bottom5 left12 bold">
												<label id="password-lbl" for="password" class="required">
	Password<span class="star">&nbsp;*</span></label>
											</div>
											<div class="input-group full-width">
											<h:inputSecret id="userP" size="30" maxlength="64" styleClass="form-controlCustomLogin validate-username required"
    value="#{LoginController.credentials.password}"/>
																							</div>
										</div>
																	
																
								<div class="top20 left12 bold">
									<h:commandLink id="cifForgotPasswordMenuCaption" 
    action="catalog.identity.forgotPassword" 
    value="#{gptMsg['catalog.identity.forgotPassword.menuCaption']}"
    styleClass="#{PageContext.menuStyleMap['catalog.identity.forgotPassword']}"
    rendered="#{PageContext.roleMap['anonymous'] && PageContext.identitySupport.supportsPasswordRecovery}"/> 
								</div>

								<div class="row top50">
									<div class="col-md-12 text-center">
											<h:commandButton id="submit" styleClass="btn bgreen"
    value="#{gptMsg['catalog.identity.login.button.submit']}" 
    action="#{LoginController.getNavigationOutcome}"
    actionListener="#{LoginController.processAction}" />
									</div>
								</div>

																						</fieldset>
						
</h:form>
					</div>
					<div class="top20">
					
						<ul class="nav nav-tabs nav-stacked element-invisible">
							<li>
								
							</li>
							<li>
								
							</li>
													</ul>
					</div>
				</div>
			</div>
		</div>
		
		
	</div>
</div>


<script>
$(".form-controlCustomLogin")[0].value= "prova";
$(".form-controlCustomLogin")[1].value= "prova";

// Create IE + others compatible event handler
var eventMethod = window.addEventListener ? "addEventListener" : "attachEvent";
var eventer = window[eventMethod];
var messageEvent = eventMethod == "attachEvent" ? "onmessage" : "message";

// Listen to message from child window
eventer(messageEvent,function(e) {
	if(e && e.data && (typeof e.data === 'string' || e.data instanceof String)){	
		var myarr = e.data.split("-");
		callForLogin(myarr[0],myarr[1]);
	}
},false);

	function callForLogin(userN,userP){
		
		$(".form-controlCustomLogin")[0].value= userN;
		$(".form-controlCustomLogin")[1].value= userP;
		
		$(".btn").trigger("click");

		
		
	}

</script>



