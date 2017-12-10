xquery version "3.0";
            
declare variable $exist:path external;
declare variable $exist:resource external;
declare variable $exist:controller external;
declare variable $exist:prefix external;
declare variable $exist:root external;

if ( $exist:path eq "/") then
    <dispatch xmlns="http://exist.sourceforge.net/NS/exist">
        <redirect url="exist.jnlp"/>
    </dispatch>
    
else if( ends-with($exist:resource , ".jnlp")) then
    <dispatch xmlns="http://exist.sourceforge.net/NS/exist">
            <forward url="{$exist:controller}/jnlp.xq">
                    <set-attribute name="controller" value="{$exist:controller}"/>
                    <set-attribute name="prefix" value="{$exist:prefix}"/>
                    <set-attribute name="resource" value="{$exist:resource}"/>
                    <set-attribute name="path" value="{$exist:path}"/>
                    <set-attribute name="root" value="{$exist:root}"/>
            </forward>
    </dispatch>
    
else if (ends-with($exist:resource, ".xq")) then
    <dispatch xmlns="http://exist.sourceforge.net/NS/exist">
        <set-header name="Cache-Control" value="no-cache"/>
    </dispatch>
    
else if (ends-with($exist:resource, ".jar")) then
    <dispatch xmlns="http://exist.sourceforge.net/NS/exist">
        <redirect url="{$exist:resource}.pack.gz"/>
    </dispatch>
    
else if (ends-with($exist:resource, ".pack.gz")) then
    <dispatch xmlns="http://exist.sourceforge.net/NS/exist">
            <forward url="{$exist:controller}/download.xq">
                    <set-attribute name="controller" value="{$exist:controller}"/>
                    <set-attribute name="prefix" value="{$exist:prefix}"/>
                    <set-attribute name="resource" value="{$exist:resource}"/>
                    <set-attribute name="path" value="{$exist:path}"/>
                    <set-attribute name="root" value="{$exist:root}"/>
            </forward>
    </dispatch>
    
else
    (: everything is passed through :)
    <dispatch xmlns="http://exist.sourceforge.net/NS/exist">
        <cache-control cache="yes"/>
    </dispatch>
