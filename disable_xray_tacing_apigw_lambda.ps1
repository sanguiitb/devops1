$profile = $OctopusParameters['AWSCLIProfileName']
<#
#Get the List of Lambda's where xray is Active
$fns= (aws lambda list-functions --query "Functions[].FunctionName" --profile webdd --output text --profile $OctopusParameters['AWSCLIProfileName'])

function XRayGet {
  param($functionName)
  $xray= (aws lambda get-function --function-name "$functionName" --profile $OctopusParameters['AWSCLIProfileName'] --query Configuration.TracingConfig.Mode)
  if ($xray -eq '"Active"'){
    write-host "Xray enabled for function: $functionName"
  }
}

foreach($f in $fns.Split('')){

#echo "Get the function details:$f"
XRayGet -functionName $f

}

#>
#Get the list of API Gateway's where the xray is enabled

$restapis = (aws apigateway get-rest-apis  --profile $profile --query items[].id --output text)

function XRayGet {
 param($gwid)
 $stage= (aws apigateway get-stages --rest-api-id $gwid --profile $profile  --query item[].stageName --output text)
 foreach($i in $stage.Split('')){
   $xray = (aws apigateway get-stage --rest-api-id $gwid --stage-name $i --profile $profile --query tracingEnabled)
   if ($xray -eq "true") { 
   	write-host "Xray enabled for Gateway: $gwid" 
        #Update Tracing to be set to false
        aws apigateway update-stage --rest-api-id $gwid --stage-name $i --profile $profile --patch-operations op=replace,path=/tracingEnabled,value=false
   }
 }
}


foreach($id in $restapis.Split('')){

  #echo "Get the ApiGateway Id details:$id"
  XRayGet -gwid $id

}

