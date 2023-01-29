#/bin/sh
SERVICE=$1
REGION=$2
NUMBER_OF_REVISIONS=$3
REVISIONS=$((1+NUMBER_OF_REVISIONS))

echo "There will be only $NUMBER_OF_REVISIONS revisions left in $SERVICE service"
gcloud alpha run revisions list --service=$SERVICE --region=$REGION --sort-by=~creationTimestamp | awk "NR > $REVISIONS { print }" | cut -d' ' -f3 > ./revisions.txt


while read revision;

 do echo "Deleting $revision revision";
    gcloud run revisions delete $revision --region=$REGION --quiet

done < ./revisions.txt
rm ./revisions.txt
