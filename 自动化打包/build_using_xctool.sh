#!/bin/bash

#./build_using_xctool.sh lzj123 /Users/lzj/Desktop/Test/TestLive EB9K2L27BQ Test com.securesmart.test 1.1.1 111 enterprise /Users/lzj/Desktop/Test/TestLive/Test_Development_RD.mobileprovision /Users/lzj/Desktop/Test/TestLive/Test_Universal_RD.mobileprovision /Users/lzj/Desktop/Test/TestLive/ios_development.p12 /Users/lzj/Desktop/Test/TestLive/ios_distribution.p12
	
	
#用户登录密码
user_password=$1				
#工程文件夹路径		
project_directory_path=$2
#开发者TeamID
team_id=$3
#App名称
app_name=$4
#App Bundle ID
bundle_id=$5
#App 版本号,eg:"1.0.0"
app_version=$6
#App 组建版本号(纯数字),eg:"100"
app_build_version=$7
#指定打包所使用的输出方式，目前支持app-store, package, ad-hoc, enterprise, development, 和developer-id，即xcodebuild的method参数
export_method=$8
#mobileprovision描述文件路径
mobileprovision_debug_path=$9
mobileprovision_release_path=${10}
#P12证书路径
certificate_debug_path=${11}
#P12证书密码
certificate_debug_pwd=${12}
#Release
certificate_release_path=${13}
certificate_release_pwd=${14}

#更新timeout
export FASTLANE_XCODEBUILD_SETTINGS_TIMEOUT=120
#计时
SECONDS=0
#取当前时间字符串添加到文件结尾
now=$(date +"%Y_%m_%d_%H_%M_%S")

#指定项目的scheme名称
scheme="Test"
#指定项目地址
workspace_path="$project_directory_path/Test.xcodeproj"
#指定要打包的配置名,格式：Debug, Release
configuration="Release"
#指定输出路径
output_path="$project_directory_path/App/${app_name}/"
#指定文件名称
ipa_file_name="${app_name}_${now}"
#指定输出ipa名称
ipa_name="${ipa_file_name}.ipa"
#指定输出归档文件地址
archive_path="$output_path/${ipa_file_name}.xcarchive"
#指定输出ipa地址
ipa_path="$output_path/${ipa_name}"
#程序Info.plist文件路径
infoPlist_path="./Test/Info.plist"

#输出设定的变量值
echo "User password: ${user_password}"
echo "Project directory path: ${project_directory_path}"
echo "App Name: ${app_name}"
echo "Pack export method: ${export_method}"
echo "Mobileprovision(debug) file path: ${mobileprovision_debug_path}"
echo "Mobileprovision(release) file path: ${mobileprovision_release_path}"
echo "Certificate(debug) P12 file path: ${certificate_debug_path}"
echo "Certificate(debug) P12 password: ${certificate_debug_pwd}"
echo "Certificate(release) P12 file path: ${certificate_release_path}"
echo "Certificate(release) P12 password: ${certificate_release_pwd}"

echo "Workspace path: ${workspace_path}"
echo "Scheme name: ${scheme}"
echo "Configuration method: ${configuration}"
echo "Archive path: ${archive_path}"
echo "IPA path: ${ipa_path}"
echo "InfoPlist path: ${infoPlist_path}"
echo "===Start run pack cmd===="


#删除keychain，需要使用
#fastlane delete_app_keychain

#新建keychain，需要使用
#fastlane create_app_keychain

#向电脑加载mobileprovision文件
open ${mobileprovision_debug_path}
open ${mobileprovision_release_path}

#加载P12文件
#debug
fastlane set_certificate userPwd:${user_password} certificatePath:${certificate_debug_path} certificatePwd:${certificate_debug_pwd}
#release
fastlane set_certificate userPwd:${user_password} certificatePath:${certificate_release_path} certificatePwd:${certificate_debug_pwd}

#更新Project Team,https://developer.apple.com/account/ios/certificate/?teamId=EB9K2L27BQ
fastlane set_project_team projectPath:${workspace_path} teamID:${team_id}

#修改App名称和BundleID
fastlane set_BundleID projectPath:${workspace_path} InfoPlistPath:${infoPlist_path} bundleID:${bundle_id} AppName:${app_name}

#加载描述文件
#debug
fastlane load_debug_provision projectPath:${workspace_path} mobileprovisionPath:${mobileprovision_debug_path}
#release
fastlane load_release_provision projectPath:${workspace_path} mobileprovisionPath:${mobileprovision_release_path}

#设置code signing为自动
#fastlane set_automatic_code_signing

#清除Xcode Derived Data数据
fastlane clear_derived_X_data

#设置bulid版本号
fastlane set_version version:${app_version} build:${app_build_version}

#是否打开推送服务:on,off

#打包IPA
fastlane gym --project ${workspace_path} --scheme ${scheme} --clean --configuration ${configuration} --archive_path ${archive_path} --export_method ${export_method} --output_directory ${output_path} --output_name ${ipa_name}

#上传到fir
#fir publish ${ipa_path} -T fir_token -c "${commit_msg}"

#输出总用时
echo "===Finished. Total time: ${SECONDS}s==="
