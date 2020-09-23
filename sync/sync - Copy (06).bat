@ECHO OFF
::This Batch file syncs this folder with Assignments
TITLE Sync in progress please wait...

@cd %UserProfile%\Desktop\Assignments\
@rclone sync %UserProfile%\Desktop\Assignments\ "AssignmentSync:RN 06" -v