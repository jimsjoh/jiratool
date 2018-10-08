;By Jim-Stefhan Johansen
;Tool to assist filling the form when creating issues in JIRA


#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
SetBatchLines, -1
#SingleInstance Force
#Persistent
Menu Tray, Icon, %A_ScriptDir%\Data\JHT.ico
BlockInput, Off
Title := "JIRA tool"

;Windows Key + V to trigger
;#v::
Gui, 1: Destroy
;Window settings
Gui, 1: -MinimizeBox -MaximizeBox -SysMenu
Gui, 1: Color, White
Gui, 1: Margin, 5, 5
;Project
Gui, 1: Add, Text, w200 h20 +0x200, Project
Gui, 1: Add, DropDownList, yp+20 vProject w200 +Sort, eCAT/XPT - Content|Localization (LOCALZN)|PP - BL-Credit|PP - BL-Global Operations|PP - BL-Risk|PP - PL-Consumer|PP - PL-Merchant|PP - PL-Payments
;Bug/improv
Gui, 1: Add, Text, yp+30 w200 h20 +0x200, Issue type
Gui, 1: Add, DropDownList, yp+20 vIssueType w200 +Sort, Improvement|Bug
;Issue category
Gui, 1: Add, Text, yp+30 w200 h20 +0x200, Issue category
Gui, 1: Add, DropDownList, vIssueCategory yp+20 w200 +Sort, CORE_FUNC|L10N_FUNC|INTL_FUNC|INTL_GUI|I18N_CHAR_SUPPORT|I18N_LOCALE|I18N_BiDi|L10N_LOCALIZABILITY|L10N - Unlocalized Content|L10N - Unadapted content|L10N - Missing Localized Content|L10N - Grammar|L10N - Terminology|L10N - Style guide errors|L10N - Typo|L10N - Unlocalised images|L10N - Ambiguous Translation|L10N - Literal Translation|L10N - Inconsistency|L10N - Mistranslation|L10N - Voice and tone|L10N - Punctuation|L10N - Spacing (missing and extra)
;Priority
Gui, 1: Add, Text, yp+30 w200 h20 +0x200, Priority
Gui, 1: Add, DropDownList, vPriority yp+20 w200 +Sort, P0 – Blocker (all teams 24/7)|P1 – Blocker (key teams 24/7)|P2 – (Critical)|P3 – (Major/Normal)|P4 – (Minor/Trivial)
;Labels
Gui, 1: Add, Text, yp+30 w200 h20 +0x200, Labels (optional)
;Gui, 1: Add, Text, yp+15 w200 h20 +0x200, Separators: comma and semicolon
Gui, 1: Add, Edit, vFeatureLabels yp+20 w200 h100 -E0x200 +Border Multi -VScroll Left
;Link to bug logging guidelines
Gui, 1: Add, Text, yp+100 w200 h18 +0x200, Bug logging guidelines
Gui, 1: Add, Link, yp+15 w200 h18, <a href="https://engineering.paypalcorp.com/confluence/pages/viewpage.action?pageId=68070263">PayPal confluence</a>
Gui, 1: Add, Link, yp+15 w200 h18, <a href="http://confluence.alphacrc.com/display/PAYP/6.4+Filing+issue+-+Bug+Logging+Guidelines">Alpha confluence</a>
;Send
Gui, 1: Add, Text, yp+20 w200 h20 +0x200, "Send" opens new tab in default browser
Gui, 1: Add, Button, gSendJIRA yp+20 w80 h25 +Default, Send
;Cancel
Gui, 1: Add, Button, gCancelJIRA x+40 w80 h25, Cancel


Gui, 1: Show, AutoSize, %Title%

Return





;Run when clicking Send button
SendJIRA:
	GuiControlGet, Project
	GuiControlGet, IssueType
	GuiControlGet, IssueCategory
	GuiControlGet, Priority
	GuiControlGet, FeatureLabels

	guivlist := [Project, IssueType, IssueCategory, Priority]

	for i,a in guivlist
	{
		if(!a)
		{
			MsgBox Required field empty. ; show error message
			return
		}
	}

	Gosub CreateURL
	Return

;Run when clicking Cancel button
CancelJIRA:
	;Gui, 1: Destroy
	;return
	exitapp

;Run when required fields pass
CreateURL:
	;Default
	MinURL := "https://engineering.paypalcorp.com/jira/secure/CreateIssueDetails!init.jspa?"

	;ProjectID
	Iniread, Projectvar, %A_ScriptDir%\Data\pid.ini, %Project%
	ProjectURL := "pid="Projectvar

	;Issuetype
	Iniread, Issuetypevar, %A_ScriptDir%\Data\issuetype.ini, %Issuetype%
	IssuetypeURL := "&issuetype="Issuetypevar

	;Summary


	;Priority
	Iniread, Priorityvar, %A_ScriptDir%\Data\priority.ini, %Priority%
	PriorityURL := "&priority="Priorityvar

	;Environment Found In
	EnvVar := "&customfield_15334=22909"

	;Affects Version/sRequired


	;Assignee


	;Verifier
	UserURL := "&customfield_11772="A_Username

	;Reporter
	ReporterURL := "&reporter="A_Username

	;Description field
	;ASCII Encoding Reference http://www.w3schools.com/tags/ref_urlencode.asp
	DescriptionURL := "&description=%2AInfo%2A%0AStage%3A%20%28xxxxxx%2Eqa%2Epaypal%2Ecom%29%0ABuild%3A%20%28add%20%2Fmeta%20to%20url%20and%20search%20buildid%20or%20%22N%2EA%2E%22%29%0AAccount%3A%20%28xxxxxxxx%40paypal%2Ecom%29%0APassword%3A%20%28xxxxxxxx%29%0AAutomation%20TC%20Link%3A%20%28when%20a%20bug%20is%20reported%20using%20automation%2C%20else%20remove%20line%29%0ATC%20Name%3A%20%28when%20a%20bug%20is%20reported%20using%20automation%2C%20else%20remove%20line%29%0APage%20URL%3A%20%28For%20bugs%20found%20through%20Automation,%20there%20is%20now%20a%20URL%20button%20to%20obtain%20this%2E%29%0A%0A%2ASTEPS%2A%0A%23%20%28provide%20step%201%29%0A%23%20%28provide%20step%202%29%0A%23%20%28provide%20step%20%2E%2E%2E%29%0A%0A%2AIssue%2A%0A%28shortly%20describe%20the%20issue%29%0A%0A%2D%20Actual%20source%3A%0A%28provide%20actual%20result%29%0A%0A%2D%20Expected%20source%3A%0A%28provide%20expected%20result%2C%20remove%20if%20no%20change%20to%20source%29%0A%0A%2D%20Actual%20target%3A%0A%28provide%20actual%20result%29%0A%0A%2D%20Expected%20target%3A%0A%28provide%20expected%20result%29%0A%0A%2AAdditional%20info%3A%2A%0A%28optional%2C%20remove%20if%20not%20used%29%0A"

	;Locale


	;Country


	;Labels
	FeatureLabels := RegExReplace(FeatureLabels, "(?!\.)(?!\/)(?!\-)[\W]+"," ")
	Loop, Parse, FeatureLabels,%A_Space%
	{
	FileAppend, &labels=%A_LoopField%, %A_ScriptDir%\Data\labelsvar.txt
	}
	Fileread, LabelsURL, %A_ScriptDir%\Data\labelsvar.txt
	LabelsURL := RegExReplace(LabelsURL, "&labels=$","")
	FileDelete, %A_ScriptDir%\Data\labelsvar.txt
	;MsgBox,%FeatureLabels%

	;Issue Category
	Iniread, Issuecatvar, %A_ScriptDir%\Data\issuecategory.ini, %IssueCategory%
	IssuecatURL := "&customfield_14638="Issuecatvar

	;Generate complete URL
	NavURL = %MinURL%%ProjectURL%%IssuetypeURL%%PriorityURL%%EnvVar%%UserURL%%ReporterURL%%DescriptionURL%%IssuecatURL%%LabelsURL%
	;MsgBox,%NavURL%
	Run, %NavURL%
	;Return
  Exitapp
