# Build images

# Get Start Time
$startDTM = (Get-Date)

# Variables
$template_file="./templates/hv_rockylinux8_g2_docker.pkr.hcl"
$var_file="./variables/variables_rockylinux86.pkvars.hcl"
$override="./variables/rockylinux8_docker.yml"
$machine="RockyLinux 8.6"
$packer_log=0

if ((Test-Path -Path "$template_file") -and (Test-Path -Path "$var_file")) {
  Write-Output "Template and var file found"
  Write-Output "Building: $machine"
  try {
    $env:PACKER_LOG=$packer_log
    packer validate -var-file="$var_file" -var "ansible_override=$override" "$template_file"
  }
  catch {
    Write-Output "Packer validation failed, exiting."
    exit (-1)
  }
  try {
    $env:PACKER_LOG=$packer_log
    packer version
    packer build --force -var-file="$var_file" -var "ansible_override=$override" "$template_file"
  }
  catch {
    Write-Output "Packer build failed, exiting."
    exit (-1)
  }
}
else {
  Write-Output "Template or Var file not found - exiting"
  exit (-1)
}

$endDTM = (Get-Date)
Write-Host "[INFO]  - Elapsed Time: $(($endDTM-$startDTM).totalseconds) seconds" -ForegroundColor Yellow
