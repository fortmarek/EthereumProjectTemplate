# Build the preprocess file
#cd ${PROJECT_DIR}/environment/

app_name=$1
app_identifier=$2
env_dir=$3

cd $env_dir

build_date=`date +%Y-%m-%d:%H:%M:%S`
preprocessFile="environment_preprocess.h"
echo "Creating header file"

echo  "//-----------------------------------------" > $preprocessFile
echo  "// Auto generated file" >> $preprocessFile
echo  "// Created $build_date" >> $preprocessFile
echo  "//-----------------------------------------" >> $preprocessFile
echo  "" >> $preprocessFile
#echo -e "#define ACK_ENVIRONMENT              $env" >> $preprocessFile
#echo -e "#define ACK_ENVIRONMENT_VERSION  $buildnum" >> $preprocessFile
echo  "#define ACK_ENVIRONMENT_APP_NAME     $app_name" >> $preprocessFile
echo  "#define ACK_ENVIRONMENT_BUNDLE_IDENTIFIER     $app_identifier" >> $preprocessFile

#dump out file to build log
cat $preprocessFile

# Force the system to process the plist file
echo "Touching plist at: /Source/Project-Info.plist"
touch ../Source/Project-Info.plist

# done
#echo "Done."