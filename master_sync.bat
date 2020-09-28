@ECHO OFF
::This Batch file syncs this folder with Assignments
TITLE Sync in progress please wait...

@rclone sync AssignmentSync: %CD% -v