#!/bin/bash

pdf_file=$1
pdfid_output=$(python /opt/remnux-didier/pdfid.py -n $pdf_file)
python /opt/remnux-didier/pdfid.py -n $pdf_file

find_url()  {
  if  [[ "$pdfid_output" == *"URI"* ]];
  then
    echo "URI Found!"
    python /opt/remnux-didier/pdf-parser.py $pdf_file|grep "/URI"
  else
    echo "No URI Found"
  fi

}

search_for_compression() {
  if [ -z "$search_for_compression" ]
  then
    echo "No Compression Found!"

  else
    echo "Compression Found!"
    echo "Decompressing...."
    decompressed_filename="Decompressed_${pdf_file}"
    qpdf --stream-data=uncompress $pdf_file $decompressed_filename
    python /opt/remnux-didier/pdfid.py -n $decompressed_filename
    find_url $decompressed_filename
  fi
}

if [ -z find_url ]
then
  search_for_compression
else
  find_url
fi

#python /opt/remnux-didier/pdf-parser.py $1|grep http > urls_found.txt

#pdf2=("uncompressed_$1")

#pdftk $1 output $pdf2 uncompress

#python /opt/remnux-didier/pdf-parser.py $pdf2 |grep http >> urls_found.txt

#cat urls_found.txt
