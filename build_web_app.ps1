$projectName = "fdg_lux_meter"
flutter build web --base-href /web/${projectName}/
Set-PSDebug -Trace 1
Remove-Item -Path "..\web\${projectName}" -Recurse -Force 
Copy-Item -Path "build\web" -Destination "..\web\${projectName}" -Recurse 
Set-PSDebug -Off