bcdedit /copy {current} /d "Disable Hyper-V"
bcdedit /set {<use the GUID from step 2>} hypervisorlaunchtype off
