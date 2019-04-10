
#Write some text
[System.Windows.Forms.SendKeys]::SendWait("Hi")
#Press on Enter
[System.Windows.Forms.SendKeys]::SendWait("{ENTER}")
#Repeat a key
[System.Windows.Forms.SendKeys]::SendWait("{RIGHT 5}")
