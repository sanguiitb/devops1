cd /e/repos
cloudfrontDistributionid="E91N06375CBR0"
$CFEtag = aws cloudfront get-distribution --id $cloudfrontDistributionid --query 'ETag' --output text --profile webdd
aws cloudfront update-distribution --id $cloudfrontDistributionid --distribution-config "file://cfdeployment.json" --if-match $CFETag --profile webdd
