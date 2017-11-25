xquery version "3.1";

declare namespace output = "http://www.w3.org/2010/xslt-xquery-serialization";

declare option output:method "xml";
declare option output:media-type "application/x-java-jnlp-file";

(: Get external URL, fix for strange response of Tomcat :)
let $url := replace(replace(request:get-url(), "/rest/db/", "/"), ".xq", ".jnlp")
let $href := tokenize($url, "/")[last()]

(: Codebase is the base URL to be able to download all other resources :) 
let $codebase := substring-before($url, $href)

(: For XMLRPC we need the part after http(s):// :)
let $xmlrpc := substring-after(substring-before($codebase, request:get-attribute("prefix") || request:get-attribute("controller")),"://")

(: Toplevel app Collection :) 
let $currentCollection := '/db' || request:get-attribute("prefix") || request:get-attribute("controller")

(: Determine the location of the jar files :) 
let $jarsCollection := $currentCollection || "/jars"

(: Get eXist-db version :) 
let $version := data(doc("exist-config.xml")//version)
return
    <jnlp spec="7.0" codebase="{ $codebase }" href="{ $href }" version="{ $version }">
    <information>
        <title>eXist-db client ({$version})</title>
        <vendor>exist-db.org</vendor>
        <homepage href="http://exist-db.org"/>
        <description>Integrated command-line and gui client, entirely based on the 
            XML:DB API and provides commands for most database related tasks, 
            like creating and removing collections, user management, batch-loading XML data
            or querying.</description>
        <description kind="short">eXist-db client</description>
        <description kind="tooltip">eXist-db client</description>
        <icon kind="splash" href="resources/images/jnlp_splash.png"/>
        <icon href="resources/images/jnlp_icon_64x64.png" width="64" height="64"/>
        <icon kind="shortcut" href="resources/images/jnlp_icon_16x16.png" width="16" height="16"/>
        <icon kind="shortcut" href="resources/images/jnlp_icon_32x32.png" width="32" height="32"/>
        <offline-allowed/>
    </information>
    <security>
        <all-permissions/>
    </security>
    <resources>
        <property name="jnlp.packEnabled" value="true"/>
        <java version="1.8+"/>
    {
        for $resource in sort(xmldb:get-child-resources($jarsCollection))
        let $stippedName := replace($resource, "jar.pack.gz", "jar")
        return
            <jar href="jars/{ $stippedName }" size="{ xmldb:size($jarsCollection, $resource) }"/>
    }
    </resources>
    <application-desc main-class="org.exist.client.InteractiveClient">
        <argument>-ouri=xmldb:exist://{ $xmlrpc }/xmlrpc</argument>
        <argument>--no-embedded-mode</argument>
        {
            if(starts-with($codebase, "https:"))            
            then
                <argument>--use-ssl</argument>
            else
                ()
        }
    </application-desc>
</jnlp>
