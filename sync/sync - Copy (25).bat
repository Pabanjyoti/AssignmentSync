@ECHO OFF
::This Batch file syncs this folder with Assignments
TITLE Sync in progress please wait...

@rclone sync %CD% "AssignmentSync:RN 25" -v