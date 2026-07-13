Scriptname COTNPersistentRefsScript1 extends Quest  

Event OnInit()
	if UpdateVersion.GetValueInt() < TargetVersion.GetValueInt()
		int size = PersistentRefs.GetSize()
		int i = 0;
		While i < size
			ObjectReference akRef = PersistentRefs.GetAt(i) as ObjectReference
			if(akRef.isEnabled())
				akRef.Disable()
				akRef.MoveToMyEditorLocation()
				akRef.Enable()
			else
				akRef.MoveToMyEditorLocation()
			endif
			i = i+1
		endWhile
		Stop()
		UpdateVersion.SetValueInt(TargetVersion.GetValueInt())
	endIf
EndEvent

FormList Property PersistentRefs  Auto  

GlobalVariable Property UpdateVersion  Auto  
GlobalVariable Property TargetVersion Auto
