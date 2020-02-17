<#
This script reads from the csv file and updates the RDS certs on AWS.
Update CSv file can be downloaded from AWS(RDS->Certificate Update-> Export List)
#>

$pathToUpdateCsv = " C:\Users\Sangeeta\Downloads\DevDBRequiringUpdate.csv"
$certIdentifier = "rds-ca-2019"
$awsCLIProfileName = "webdd"

Import-Csv $pathToUpdateCsv | select -ExpandProperty "DB identifier" | foreach {
    
   Write-host "DBIdentifier: $_"

   aws rds modify-db-instance --db-instance-identifier $_ --ca-certificate-identifier $certIdentifier  --apply-immediately --profile $awsCLIProfileName

}
