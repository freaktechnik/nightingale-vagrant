# Install the deps that aren't on the VM yet.
echo "\n" | cmd /C "choco install -y 7Zip"
echo "\n" | cmd /C "choco install -y mozillabuild"
echo "\n" | cmd /C "choco install -y -v windows-sdk-7.0"
echo "\n" | cmd /C "choco install -y git"
echo "\n" | cmd /C "choco install -y pstools"

local_src="/cygdrive/c/temp/nightingale-hacking"

# Copy the Nightingale source into a non-shared folder
xcopy /y/s/e/k/z/i "C:\nightingale-hacking" "C:\temp\nightingale-hacking"



# Add system-specific build config settings
echo 'ac_add_options --with-taglib-source=packaged' >> $local_src/nightingale.config
echo 'ac_add_options --disable-compiler-environment-checks' >> $local_src/nightingale.config
echo 'ac_add_options --with-media-core=default' >> $local_src/nightingale.config
echo 'ac_add_options --enable-installer' >> $local_src/nightingale.config
echo 'ac_add_options --with-msvc-express' >> $local_src/nightingale.config

# BUILD, run as user, since else msvc craps itself and displays unrelated errors.
psexec -h -u vagrant -p vagrant psexec -accepteula "C:\vagrant\start-msvc9.bat"

# Sync the build and installer to the host machine
xcopy /y/s/e/k/z/i "C:\temp\nightingale-hacking\compiled\dist" "C:\vagrant\dist"
xcopy /y/s/e/k/z/i "C:\temp\nightingale-hacking\compiled\_built_installer" "C:\vagrant\installer"
