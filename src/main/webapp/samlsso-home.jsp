<%@ page import="java.util.Map" %>
<%@ page import="java.util.Set" %>
<%@page import="org.wso2.carbon.user.api.UserRealm" %>
<%@page import="org.wso2.carbon.context.CarbonContext" %>
<%@ page import="org.wso2.carbon.context.RegistryType" %>
<%@ page import="org.wso2.carbon.registry.api.Registry" %>
<%@ page import="org.wso2.carbon.registry.api.Resource" %>
<!--
~ Copyright (c) 2005-2010, WSO2 Inc. (http://www.wso2.org) All Rights Reserved.
~
~ WSO2 Inc. licenses this file to you under the Apache License,
~ Version 2.0 (the "License"); you may not use this file except
~ in compliance with the License.
~ You may obtain a copy of the License at
~
~    http://www.apache.org/licenses/LICENSE-2.0
~
~ Unless required by applicable law or agreed to in writing,
~ software distributed under the License is distributed on an
~ "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
~ KIND, either express or implied.  See the License for the
~ specific language governing permissions and limitations
~ under the License.
-->
<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
"http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
    <link rel="stylesheet" type="text/css" href="css/cart-styles.css">
    <title>WSO2</title>
</head>
<body>
<%
    String subject = (String) request.getSession().getAttribute("Subject");
    if(subject == null){
%>
        <script type="text/javascript">
            location.href = "index.jsp";
        </script>
<%
        return;
    }
%>
<div id="container">
    <div id="header-area">
        <img src="images/cart-logo.gif" alt="Logo" vspace="10" />

    </div>
    <!-- Header-are end -->

    <div id="content-area">
        <div class="cart-tabs">
            <table cellpadding="0" cellspacing="0" border="0">
                <tr>
                    <td class="cart-tab-left"><img src="images/cart-tab-left.gif"
                                                   alt="-"></td>
                    <td class="cart-tab-mid"><a>Home</a></td>
                    <td class="cart-tab-right"><img
                            src="images/cart-tab-right.gif" alt="-"></td>
                </tr>
            </table>
        </div>
        <table cellpadding="0" cellspacing="0" border="0" class="cart-expbox">
            <tr>
                <td><img src="images/cart-expbox-01.gif" alt="-"></td>
                <td class="cart-expbox-02">&nbsp</td>
                <td><img src="images/cart-expbox-03.gif" alt="-"></td>
            </tr>
            <tr>
                <td class="cart-expbox-08">&nbsp</td>
                <td class="cart-expbox-09">
                    <!--all content for cart and links goes here-->
                </td>
                <td class="cart-expbox-04">&nbsp</td>
            </tr>
            <tr>
                <td><img src="images/cart-expbox-07.gif" alt="-"></td>
                <td class="cart-expbox-06">&nbsp</td>
                <td><img src="images/cart-expbox-05.gif" alt="-"></td>
            </tr>

        </table>
        <h1>Travelocity.COM</h1>
        <hr />
        <div class="product-box">
            <h2> You are logged in as <%=subject%></h2>
            <a href="../avis.com"> Avis.COM </a>
            <table>
                <%
                    Set<Map.Entry<String,String>> attributes = ((Map<String,String>)session.getAttribute("SubjectAttributes")).entrySet();
                    for (Map.Entry<String, String> entry:attributes) {
                %>
                <tr>
                    <td><%=entry.getKey()%></td>
                    <td><%=entry.getValue()%></td>
                </tr>
                <%
                    }
                %>
            </table>
            <a href="index.jsp">Go to Login page</a>
            <hr/>
            <!--Start of The user list-->
            <p><b>The user list</b></p>
				<%
					// Obtain the reference to the UserRealm from the CarbonContext
				    CarbonContext context = CarbonContext.getCurrentContext();
				    UserRealm realm = context.getUserRealm();
				    String[] names = realm.getUserStoreManager().listUsers("*", 100);
				    for (String name : names) {
				%><%=name%><br/><%
				    }
				%>
            <!--End of The user list-->
            <!--Start of The Registry access-->
            <h2>WSO2 Carbon Registry Usage</h2>
					<hr/>
					<p>
					
					<h3>Add New Resource to the Registry</h3>
					<p>
					<form action="samlsso-home.jsp" method="POST">
					    <table border="0">
					        
					        <tr>
					            <td>Resource Path</td>
					            <td><input type="text" name="resourcePath" value="foo/bar"/></td>
					        </tr>
					        <tr>
					            <td>Value</td>
					            <td><input type="text" name="value" value="WSO2 Carbon"/></td>
					        </tr>
					        <tr>
					            <td>&nbsp;</td>
					            <td><input type="submit" value="Add" name="add"></td>
					        </tr>
					         <tr>
					            <td>Resource Path</td>
					            <td><input type="text" name="resourcePath" value="foo/bar"/></td>
				        	</tr>
				        	<tr>
					            <td>&nbsp;</td>
					            <td><input type="submit" value="View" name="view"></td>
				        </tr>
					    </table>
					</form>
					</p>
					<hr/>
					<p>
					<%
					    // Obtain the reference to the registry from the CarbonContext
					    CarbonContext cCtx = CarbonContext.getCurrentContext();
					
					    Registry registry = cCtx.getRegistry(RegistryType.SYSTEM_CONFIGURATION);
					    registry = cCtx.getRegistry(RegistryType.SYSTEM_GOVERNANCE);
					    
					
					    if (request.getParameter("add") != null) {
					        Resource resource = registry.newResource();
					        resource.setContent(request.getParameter("value"));
					        String resourcePath = request.getParameter("resourcePath");
					        registry.put(resourcePath, resource);
					    } else if (request.getParameter("view") != null) {
					        String resourcePath = request.getParameter("resourcePath");
					        if (registry.resourceExists(resourcePath)) {
					            Resource resource = registry.get(resourcePath);
					            String content = new String((byte[]) resource.getContent());
					            response.addHeader("resource-content", content);
					            
					    		%>
							    <p>
		                		Resource at in Registry <%= RegistryType.SYSTEM_GOVERNANCE%> path <%= resourcePath%> : <%= content %>
		            			</p>
            					<%
            					
            				}
            			}  
            			%>

            <!--End of The Registry access-->
            <form action="logout">
                <input type="submit" value="Logout">
            </form>
        </div>
    </div>
    <!-- content-area end -->


    <div id="footer-area">
        <p>©2013 WSO2</p>
    </div>
</div>
</body>
</html>