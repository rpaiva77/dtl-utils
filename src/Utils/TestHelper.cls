Class Utils.TestHelper Extends %RegisteredObject
{

ClassMethod GenerateOutputFiles(ByRef source, ByRef target, path As %String, dtlname As %String, filename As %String = "") As %Status
{
	set ret = $$$OK
	quit:'($g(^ISCLogDTLObjs)) 
	try {
		set:(filename="") filename=$zstrip($zdt($ztimestamp,3,,3),"*P")
		if ($$$isWINDOWS){
			set pathdtl=path_"\"_dtlname_"\"
		}else{ 
			set pathdtl=path_"/"_dtlname_"/"
		}
		if '##class(%File).DirectoryExists(pathdtl){
			s sc=##class(%File).CreateDirectory(pathdtl)
			$$$ThrowOnError(sc)	
		}	
		set tSourceFileName=pathdtl_filename_".IN"
		set ret=..ExportObject(source,tSourceFileName)
		set tTargetFileName=pathdtl_filename_".OUT"
		set ret=..ExportObject(target,tTargetFileName)
		} catch ex {
		set ret = ex.AsStatus()
	}
	quit ret
}

ClassMethod ExportObject(ByRef obj, path As %String) As %Status
{
	set ret = $$$OK
	try {
		set classname = $classname(obj)
		if classname="EnsLib.HL7.Segment" {
			set st = $method(obj, "OutputToString")
			set file = ##class(%Stream.FileCharacter).%New()
			set file.Filename = path
			do file.Write(st)
			$$$ThrowOnError(file.%Save())
		} 
		elseif classname="EnsLib.HL7.Message" {
			set sc = $method(obj, "OutputToFile", path, 1)
			$$$ThrowOnError(sc)
		}
		else {
			set writer = ##class(%XML.Writer).%New()
			set writer.Indent=1
			set writer.NoXMLDeclaration=1
			$$$ThrowOnError(writer.OutputToFile(path))
			$$$ThrowOnError(writer.RootObject(obj))
		}
	} catch ex {
		set ret = ex.AsStatus()
	}
	quit ret
}

}
