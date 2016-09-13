# environment variable from value passed in to xcodebuild.
# if not specified, we default to DEV

env=$1;
env_dir=$2;

echo "Setting environment $env"

cd $env_dir

build_date=`date +%Y-%m-%d:%H:%M:%S`
current_environment_file='.current_environment'
echo "Creating current environment file $current_environment_file"

echo  "$env" > $current_environment_file
#echo -e "#define ACK_ENVIRONMENT_VERSION  $buildnum" >> $preprocessFile
#echo  "#define ACK_ENVIRONMENT_APP_NAME     $app_name" >> $preprocessFile
#echo  "#define ACK_ENVIRONMENT_BUNDLE_IDENTIFIER     $app_identifier" >> $preprocessFile

#dump out file to build log
cat $current_environment_file

