Task default -Depends Build

Task Build {
    & "C:\\Program Files (x86)\\MSBuild\\12.0\\Bin\\MSBuild.exe" /nologo /v:q /filelogger BuildAll.csproj    
}

Task Tests {
    & install\build\bin\oscript.exe tests\testrunner.os -runall tests
}

Task Mono {
    & xbuild /nologo /v:q src\1Script_Mono.sln
}