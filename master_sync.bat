@ECHO OFF
::This Batch file syncs this folder with Assignments
TITLE Sync in progress please wait...

@cd %UserProfile%\Desktop\3rd_Sem_Assignments\
@rclone sync AssignmentSync: %UserProfile%\Desktop\3rd_Sem_Assignments\ -v