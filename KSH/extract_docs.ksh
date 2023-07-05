#!/usr/bin/ksh

ROOTDIR=/home/priyesh/projects/TS1
WORKDIR=$ROOTDIR/work
DATA_ROOT=/mnt/data/projects/TS1/data/R1000
TMPDIR=$ROOTDIR/tmp

SEC_FILINGS=$DATA_ROOT/filings/sec-edgar-filings
DEST_ROOT=$DATA_ROOT/stage1

TMP=${TMPDIR}/extract_docs.tmp
TMP1=${TMPDIR}/extract_docs.tmp1
TMP2=${TMPDIR}/extract_docs.tmp2

CIK_MAP=$ROOTDIR/files/ticker_CIK_mapping.txt

cd $SEC_FILINGS

for SYMBOL in `cat /tmp/tickers`
do
  echo "SYMBOL:" ${SYMBOL}

  SRC_DATA=${SEC_FILINGS}/${SYMBOL}/10-K

  # Lookup CIK for SYMBOL

  CIK=`awk -v pat=$SYMBOL '$1 == pat {print $2}' $CIK_MAP`

  if [ -z $CIK ]
  then
    echo "ERROR: Failed to lookup CIK for "$SYMBOL
    exit 1 
  fi
 
  for FILING in ${SRC_DATA}/*
  do
    echo $FILING

    cd $FILING

    f=full-submission.txt

    # Uncompress file if it is compressed

    if [ -f 'full-submission.txt.gz' ]
    then
      echo $f  
      gzip -d $f 
    fi

    # Validate filing by checking CIK

    grep 'CENTRAL INDEX KEY:' $f | awk '{print $4}' >$TMP1

    # Allow for possibility of more than one CIK found

    R=`awk -v pat=$CIK '$1 == pat {print $1}' $TMP1`

    if [ -z $R ]
    then
      # Skip filing if CIK not matched

      echo "CIK for "$SYMBOL" not found"
    else 
      # Create directory in stage 1 

      F=`basename $FILING`
      YR=`echo $F | cut -d'-' -f 2`

      DEST=$DEST_ROOT/$SYMBOL/$YR
      mkdir -p $DEST

      # Copy full-submission.txt to stage1

      cp full-submission.txt $DEST/.

      # If a gzip file already exists then we have an error.
      # Otherwise gzip.

      if [[ -f $DEST/full-submission.txt.gz ]]
      then
        echo "ERROR: "$SYMBOL" "$CIK" "$F
        echo "ERROR: gzipped full-submission.txt found unexpectedly."
      else
        gzip $DEST/full-submission.txt
      fi
   
      #Determine start line with match on FILENAME. Deduct 3 to get line
      #with document

      echo "f="$f

      S=`grep -n '<FILENAME>FilingSummary.xml' $f | head -1 | cut -d ":" -f 1`

      if [[ $S == +([0-9]) ]]
      then
        echo "S="$S
        let S=$S-3

        # Look for end of document. Search for next /DOCUMENT tag which comes
        # after the start position.  

        # Extract document and copy to stage 1

        grep -n '</DOCUMENT>' $f | cut -d ":" -f 1 | \
          awk -v x=$S '{if($1>x) print$1}' | head -1 > $TMP2 

        E=`cat $TMP2 | cut -d" " -f 1`

        if [[ $E == +([0-9]) ]] 
        then 
          echo "E="$E" S="$S 
          let DIFF=$E-$S+1
          head -$E $f | tail -$DIFF >$DEST/FilingSummary.xml
        else
          # Can't find tag to mark end of document
          pwd
          echo "ERROR: "$SYMBOL" "$CIK" "$F
          echo "ERROR: /DOCUMENT tag not found"
        fi
      else
        # Can't find document.
        echo "ERROR: "$SYMBOL" "$CIK" "$F
        echo "ERROR: FilingSummary.xml not found"
      fi 

    fi

    # Compress file

    gzip $f
  done
done
