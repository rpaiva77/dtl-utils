# dtl-utils
Utility method to export source and target objects of any DTL. 

Description:
  This method is controlled by a global ^ISCLogDTLObjs. If ^ISCLogDTLObjs=1 it runs. Otherwise nothing happens. Set it on/off as you may need.
  It will create a folder per DTL. It will generate a pair of files for every execution - name.IN and name.OUT

To use it:
  set ^ISCLogDTLObjs=1 in the applicable NS. 
  Append: do ##class(TestHelper.Utils).GenerateOutputFiles(source,target,"path to destination folder",$this) as a code block on every DTL.
