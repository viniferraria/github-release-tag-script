#!/bin/bash

access_token=efef76433f27e09568a91e58deaf025f295e45aa
# version_number=1.1.2

# if [[ $version_number == "0" ]]; then
# echo -n "Version number: "
#     read version_number
#     sed -i "4s/.*version_number.*/version_number=$version_number/" release.sh
# else
#     echo -n "Version upgrade(patch,minor,major) "
#     read version_upgrade
#     while [ "$version_upgrade" != "patch" ] && [ "$version_upgrade" != "minor" ] && [ "$version_upgrade" != "major" ]
#     do
#         echo -n "Version upgrade(minor,) "
#         read version_upgrade
#     done 
#     if [[ $version_upgrade == 'patch' ]];then
#         version_number = $version_number + 1
#         sed -i "4s/.*version_number.*/version_number=$version_number/" release.sh
#     elif [[ $version_upgrade == 'minor' ]];then
#         version_number = version_number + 1
#         sed -i "4s/.*version_number.*/version_number=$version_number/" release.sh
#     else
#         version_number = $version_number + 1
#     fi
# fi

echo -n "Tag name: "
read tag_name


echo -n "Target commitish: "
read target_commitish


echo -n "Name: "
read name


echo -n "Body? (y/n) "
read body
while [ "$body" != "y" ] && [ "$body" != "n" ]
do
    echo -n "Body? (y/n) "
    read body
done
if [[ $body == 'y' ]]; then
    echo -n "Body: "
    read body
else
    body="Release of $tag_name"
fi


echo -n "Draft? (y/n) "
read draft
while [ "$draft" != "y" ] && [ "$draft" != "n" ]
do
    echo -n "Draft? (y/n) "
    read draft
done
if [[ $draft == "y" ]]; then
    draft=true
else
    draft=false
fi


echo -n "Prerelease? (y/n) "
read prerelease
while [ "$prerelease" != "y" ] && [ "$prerelease" != "n" ]
do
    echo -n "Prerelease? (y/n) "
    read prerelease
done
if [[ $prerelease == "y" ]]; then
    prerelease=true
else
    prerelease=false
fi

if [[ $access_token == "0" ]]; then
    echo -n "Token: "
    read new_token
    sed -i "3s/.*access_token.*/access_token=$new_token/" release.sh
    access_token=$new_token
fi 

echo '{
    "tag_name": "'"${tag_name}"'",
    "target_commitish": "'"${target_commitish}"'",
    "name": "'"${name}"'",
    "body": "'"${body}"'",
    "draft": '$draft',
    "prerelease": '$prerelease'
}'   

echo -n "Do you want to confirm? (y/n): "
read confirmation
if [[ $confirmation == "y" ]]; then
    curl -d '{"tag_name": "'"${tag_name}"'","target_commitish": "'"${target_commitish}"'","name": "'"${name}"'","body": "'"${body}"'","draft": '$draft',"prerelease": '$prerelease'}' https://api.github.com/repos/cdt-baas/m2y_lib_android/releases?access_token=$access_token
else
    echo -n "Closing..."
fi
