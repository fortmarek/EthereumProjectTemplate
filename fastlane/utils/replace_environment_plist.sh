echo "Starting environment configuration "

# environment variable from value passed in to xcodebuild.
# if not specified, we default to DEV

env=$1;
env_dir=$2;

if [ -z "$env" ]; then
env="Development"
fi
echo "Using $env environment"

#copy
echo "Copying /environment/environment-$env.plist"
cp $env_dir/environment-$env.plist $env_dir/environment.plist