#!/bin/bash
for arg in $(find data -type f)
do
  echo '  <rdf:Description rdf:about="file://root/project/'$arg'">' >> metadat.rdf
  echo '     <icpsr:MD5>'$(md5sum $arg | awk ' { print $1} ')'</icpsr:MD5>' >> metadat.rdf
  echo '     <icpsr:fileContentType>'$(file -b --mime-type $arg)'</icpsr:fileContentType>' >> metadat.rdf
  echo '     <dcterms:description>'$(basename $arg)'</dcterms:description>' >> metadat.rdf
  echo '  </rdf:Description>' >> metadat.rdf
done
