rem Install the deps that aren't on the VM yet.
@powershell -NoProfile -ExecutionPolicy unrestricted -Command "iex ((new-object net.webclient).DownloadString('https://chocolatey.org/install.ps1'))" && SET PATH=%PATH%;%ALLUSERSPROFILE%\chocolatey\bin
choco install -y mozillabuild windows-sdk-7.0 git pstools visualstudioexpress2008

set LOCALSRC=%TEMP%\nightingale-hacking

rem Copy the Nightingale source into a non-shared folder
xcopy /y/s/e/k/z/i "C:\nightingale-hacking" %LOCALSRC%

rem Add system-specific build config settings
echo 'ac_add_options --with-taglib-source=packaged' >> %LOCALSRC%\nightingale.config
echo 'ac_add_options --disable-compiler-environment-checks' >> %LOCALSRC%\nightingale.config
echo 'ac_add_options --with-media-core=default' >> %LOCALSRC%\nightingale.config
echo 'ac_add_options --enable-installer' >> %LOCALSRC%\nightingale.config
echo 'ac_add_options --with-msvc-express' >> %LOCALSRC%\nightingale.config

rem BUILD, run as user, since else msvc craps itself and displays unrelated errors.
psexec -h -u vagrant -p vagrant -accepteula "C:\vagrant\start-msvc9.bat"

rem Sync the build and installer to the host machine
xcopy /y/s/e/k/z/i %LOCALSRC%\compiled\dist "C:\vagrant\dist"
xcopy /y/s/e/k/z/i %LOCALSRC%\compiled\_built_installer "C:\vagrant\installer"
