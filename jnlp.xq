xquery version "3.1";

declare namespace output = "http://www.w3.org/2010/xslt-xquery-serialization";

declare option output:method "xml";
declare option output:media-type "application/x-java-jnlp-file";

(: Get external URL, fix for strange response of Tomcat :)
let $url := replace(request:get-url(), "/rest/db/", "/")
let $href := tokenize($url, "/")[last()]

(: Codebase is the base URL to be able to download all other resources :)
let $codebase := substring-before($url, $href)

(: Toplevel app Collection :)
let $currentCollection := '/db' || request:get-attribute("prefix") || request:get-attribute("controller")

(: Determine the location of the jar files :)
let $jarsCollection := $currentCollection || "/jars"

(: Get eXist-db version :)
let $version := data(doc("exist-config.xml")//version)

return
    <jnlp spec="7.0" codebase="{ $codebase }" href="{ $href }" version="{$version}">
    <information>
        <title>eXist XML-DB client</title>
        <vendor>exist-db.org</vendor>
        <homepage href="http://exist-db.org"/>
        <description>Integrated command-line and gui client, entirely based on the XML:DB API and provides commands for
            most database related tasks, like creating and removing collections, user management, batch-loading XML data
            or querying.</description>
        <description kind="short">eXist XML-DB client</description>
        <description kind="tooltip">eXist XML-DB client</description>
        <icon href="resources/images/jnlp_logo.jpg"/>
        <icon href="resources/images/jnlp_icon_128x128.gif" width="128" height="128"/>
        <icon href="resources/images/jnlp_icon_64x64.gif" width="64" height="64"/>
        <icon href="resources/images/jnlp_icon_32x32.gif" width="32" height="32"/>
    </information>
    <security>
        <all-permissions/>
    </security>
    <resources>
        <property name="jnlp.packEnabled" value="true"/>
        <property name="java.util.logging.manager" value="org.apache.logging.log4j.jul.LogManager"/>
        <java version="1.8+"/>
    {
        for $resource in sort(xmldb:get-child-resources($jarsCollection))
        let $stippedName := replace($resource, "jar.pack.gz", "jar")
        return
                <jar href="jars/{ $stippedName }" size="{ xmldb:size($jarsCollection, $resource) }"/>
    }
    </resources>
    <application-desc main-class="org.exist.client.InteractiveClient">
        <argument>-ouri=xmldb:exist://localhost:8080/exist/xmlrpc</argument>
        <argument>--no-embedded-mode</argument>
    </application-desc>
</jnlp>
