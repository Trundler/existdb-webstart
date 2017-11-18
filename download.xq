xquery version "3.1";

declare namespace output = "http://www.w3.org/2010/xslt-xquery-serialization";

let $collection := '/db' || request:get-attribute("prefix") || request:get-attribute("controller") || "/jars/"
let $resource := request:get-attribute("resource")
let $path := $collection || request:get-attribute("resource")

return
    if (util:binary-doc-available($path))
     then
         let $resp := response:set-header("content-encoding", "pack200-gzip")
         let $resp := response:set-header("Content-Length", ""||xmldb:size($collection, $resource))
         let $binary-data := util:binary-doc($path)
         return
            response:stream-binary($binary-data, "application/x-java-pack200", request:get-attribute("resource"))
            
    else response:set-status-code(404)