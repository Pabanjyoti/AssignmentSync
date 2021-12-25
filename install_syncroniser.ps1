# Copyright 2020 Paban
param (
  [string] $version
)

$PSMinVersion = 3

# Helper functions for pretty terminal output.
function Write-Part ([string] $Text) {
  Write-Host $Text -NoNewline
}

function Write-Emphasized ([string] $Text) {
  Write-Host $Text -NoNewLine -ForegroundColor "Cyan"
}

function Write-Done {
  Write-Host " > " -NoNewline
  Write-Host "OK" -ForegroundColor "Green"
}

if ($PSVersionTable.PSVersion.Major -gt $PSMinVersion) {
  $ErrorActionPreference = "Stop"

  # Enable TLS 1.2 since it is required for connections to GitHub.
  [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

  if (-not $version) {
    # Determine latest rclone release via GitHub API.
    $latest_release_uri =
    "https://api.github.com/repos/rclone/rclone/releases/latest"
    Write-Part "DOWNLOADING    "; Write-Emphasized $latest_release_uri
    $latest_release_json = Invoke-WebRequest -Uri $latest_release_uri -UseBasicParsing
    Write-Done

    $version = ($latest_release_json | ConvertFrom-Json).tag_name -replace "v", ""
  }

  # Create ~\.config directory if it doesn't already exist
  $conf_dir = "${HOME}\.config\rclone"
  if (-not (Test-Path $conf_dir)) {
    Write-Part "MAKING FOLDER  "; Write-Emphasized $conf_dir
    New-Item -Path $conf_dir -ItemType Directory | Out-Null
    Write-Done
  }

  # Create ~\rclone-cli directory if it doesn't already exist
  $rcln_dir = "${HOME}\rclone"
  if (-not (Test-Path $rcln_dir)) {
    Write-Part "MAKING RCLONE FOLDER  "; Write-Emphasized $rcln_dir
    New-Item -Path $rcln_dir -ItemType Directory | Out-Null
    Write-Done
  }

  # Download release.
  $zip_file = "${rcln_dir}\rclone-v${version}-windows-386.zip"
  $download_uri = "https://github.com/rclone/rclone/releases/download/" +
  "v${version}/rclone-v${version}-windows-386.zip"

  Write-Part "DOWNLOADING    "; Write-Emphasized $download_uri
  Invoke-WebRequest -Uri $download_uri -UseBasicParsing -OutFile $zip_file
  Write-Done

  # Download config.
  $conf_file = "${conf_dir}\rclone.conf"
  $conf_uri = "https://raw.githubusercontent.com/Pabanjyoti/AssignmentSync/master/rclone.conf"

  Write-Part "DOWNLOADING    "; Write-Emphasized  $conf_uri
  Invoke-WebRequest -Uri $conf_uri -UseBasicParsing -OutFile $conf_file
  Write-Done

  # Extract rclone.exe and assets from .zip file.
  Write-Part "EXTRACTING     "; Write-Emphasized $zip_file
  Write-Part " into "; Write-Emphasized ${rcln_dir};
  # Using -Force to overwrite rclone.exe and assets if it already exists
  Expand-Archive -Path $zip_file -DestinationPath $rcln_dir -Force
  Write-Done

  # Remove .zip file.
  Write-Part "REMOVING       "; Write-Emphasized $zip_file
  Remove-Item -Path $zip_file
  Write-Done

  # Get Path environment variable for the current user.
  $user = [EnvironmentVariableTarget]::User
  $path = [Environment]::GetEnvironmentVariable("PATH", $user)

  # Check whether rclone dir is in the Path.
  $paths = $path -split ";"
  $is_in_path = $paths -contains "${rcln_dir}\rclone-v${version}-windows-386" -or $paths -contains "${rcln_dir}\rclone-v${version}-windows-386\"

  # Add rclone dir to PATH if it hasn't been added already.
  if (-not $is_in_path) {
    Write-Part "ADDING         "; Write-Emphasized $rcln_dir; Write-Part " to the "
    Write-Emphasized "PATH"; Write-Part " environment variable..."
    [Environment]::SetEnvironmentVariable("PATH", "${path};${rcln_dir}\rclone-v${version}-windows-386", $user)
    # Add rclone to the PATH variable of the current terminal session
    # so `rclone` can be used immediately without restarting the terminal.
    $env:PATH += ";${rcln_dir}\rclone-v${version}-windows-386"
    Write-Done
  }

  #Make Assignment directory
  $confirmation = Read-Host "Syncronise a single Roll No. only?[syncronising every roll no. will consume more data](y/n)"
  if ($confirmation -eq 'y') {

    # Create ~\Desktop\Assignments directory if it doesn't already exist
    $assign_dir = "${HOME}\Desktop\Assignments"
    if (-not (Test-Path $assign_dir)) {
      Write-Part "MAKING ASSIGNMENT FOLDER  "; Write-Emphasized $assign_dir
      New-Item -Path $assign_dir -ItemType Directory | Out-Null
      Write-Done
    }

    # Download Uploder Script.
    $roll_no = Read-Host "Please enter your roll no(eg: '01')"
    $bat_file = "${assign_dir}\sync.bat"
    $sync_uri = "https://raw.githubusercontent.com/Pabanjyoti/AssignmentSync/master/sync/" +
    "sync%20-%20Copy%20(${roll_no}).bat"
    
    Write-Part "DOWNLOADING    "; Write-Emphasized $sync_uri
    Invoke-WebRequest -Uri $sync_uri -UseBasicParsing -OutFile $bat_file
    $first_run = rclone copy `"AssignmentSync:RN ${roll_no}`" $assign_dir
    Write-Done
  } else {
    # Create ~\Desktop\Assignments directory if it doesn't already exist
    $assign_dir = "${HOME}\Desktop\3rd_Sem_Assignments"
    if (-not (Test-Path $assign_dir)) {
      Write-Part "MAKING ASSIGNMENT FOLDER  "; Write-Emphasized $assign_dir
      New-Item -Path $assign_dir -ItemType Directory | Out-Null
      Write-Done
    }

    # Download Uploder Script.
    $bat_file = "${assign_dir}\sync.bat"
    $sync_uri = "https://raw.githubusercontent.com/Pabanjyoti/AssignmentSync/master/master_sync.bat"
    
    Write-Part "DOWNLOADING    "; Write-Emphasized $sync_uri
    Invoke-WebRequest -Uri $sync_uri -UseBasicParsing -OutFile $bat_file
    $first_run = rclone copy AssignmentSync: $assign_dir\
    Write-Done
  }

  Write-Done "`n rclone was installed successfully."
  Write-Part "Run "; Write-Emphasized "rclone --help"; Write-Host " to get started.`n"
}
else {
  Write-Part "`nYour Powershell version is lesser than "; Write-Emphasized "$PSMinVersion";
  Write-Part "`nPlease, update your Powershell downloading the "; Write-Emphasized "'Windows Management Framework'"; Write-Part " greater than "; Write-Emphasized "$PSMinVersion"
}
