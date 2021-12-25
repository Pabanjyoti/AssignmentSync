# AssignmentSync

This is created to sync files with gdrive from PC with ease.
(Contact me for rclone password)

## Features

- Syncronise your assignment folder to GDrive with some simple clicks.
- Maintain your assignment folder.
- Download assignments of the whole semester for reviewing purpose.
- No need to navigate through browser, no slow uploading hassle.

## Requirements

- Windows PC with Powershell installed. (usually comes pre-installed)
- A working internet connection.

## Setup

### Single Roll No

- Make sure there already exists a folder on your Roll No. in [GDrive](https://drive.google.com/drive/folders/0AIkCYEURfAPlUk9PVA). If not make one.
- If your Roll No is 1 then your foldername should be `RN 01`
- Open Start Menu and search for `Powershell`.
- Run Powershell as Admin.
- Copy and paste below line 
```
Invoke-WebRequest -UseBasicParsing "https://raw.githubusercontent.com/Pabanjyoti/AssignmentSync/master/install_syncroniser.ps1" | Invoke-Expression
```
- There will be a prompt if you want to syncronise a single Roll No Folder or the Whole Gdrive.
- Type `y` for syncronising a single Roll No, then it will ask for a Rol No., type your roll no in two digit format(i.e.: type `01` if your roll no is 1)
- Then it will create a folder names 'Assignments' in Desktop.
- It will download the priviously uploaded files to this newly created folder.
- It will download a BAT file for one-click Syncronisation.
- You can then copy your assignment pdfs to this folder and just doubleclick the bat file to upload.

### Download all files

- Open Start Menu and search for `Powershell`.
- Run Powershell as Admin.
- Copy and paste below line 
```
Invoke-WebRequest -UseBasicParsing "https://raw.githubusercontent.com/Pabanjyoti/AssignmentSync/master/install_syncroniser.ps1" | Invoke-Expression
```
- There will be a prompt if you want to syncronise a single Roll No Folder or the Whole Gdrive.
- Type `n` for syncronising the whole GDrive to your pc.
- It will create a folder named `3rd_Sem_Assignments` on your Desktop where all folders from the GDrive will be copied.
- Then it will create a bat file to mirror gdrive files to that folder.
- This wil only work in single direction. (i.e.: this bat file can not upload files to gdrive.)
