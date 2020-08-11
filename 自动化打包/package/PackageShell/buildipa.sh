#!/bin/bash

#timeout
export FASTLANE_XCODEBUILD_SETTINGS_TIMEOUT=120

#
SECONDS=0

#
project_path=$(pwd)
#
now=$(date +"%Y_%m_%d_%H_%M_%S")

#scheme
scheme="DemoScheme"
#
configuration="Adhoc"
#app-store, package, ad-hoc, enterprise, development, developer-idxcodebuildmethod
export_method='ad-hoc'

#scheme/target/configuration`xcodebuild -list`

#
workspace_path="$project_path/Demo.xcworkspace"
#
output_path="/Users/your_username/Documents/"
#
archive_path="$output_path/Demo_${now}.xcarchive"
#ipa
ipa_path="$output_path/Demo_${now}.ipa"
#ipa
ipa_name="Demo_${now}.ipa"
#commit message
commit_msg="$1"

#
echo "===workspace path: ${workspace_path}==="
echo "===archive path: ${archive_path}==="
echo "===ipa path: ${ipa_path}==="
echo "===export method: ${export_method}==="
echo "===commit msg: $1==="

#build
fastlane gym --workspace ${workspace_path} --scheme ${scheme} --clean --configuration ${configuration} --archive_path ${archive_path} --export_method ${export_method} --output_directory ${output_path} --output_name ${ipa_name}

#fir
fir publish ${ipa_path} -T fir_token -c "${commit_msg}"

#
echo "===Finished. Total time: ${SECONDS}s==="

xi_lin
http://www.jianshu.com/p/54ab07f2e63b

