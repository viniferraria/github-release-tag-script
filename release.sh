#!/bin/bash
​
access_token=efef76433f27e09568a91e58deaf025f295e45aa
# version_number=1.1.2
​
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
​
echo -n "Version number: "
read version_number
​
echo -n "Branch name: "
read branch
​
​
echo -n "Prerelease(y/n)? "
read prerelease
while [ "$prerelease" != "y" ] && [ "$prerelease" != "n" ]
do
    echo -n "Prerelease(y/n)? "
    read prerelease
done
if [[ $prerelease == "y" ]]; then
    prerelease=true
else
    prerelease=false
fi
​
​
echo -n "Body(y/n)? "
read body
while [ "$body" != "y" ] && [ "$body" != "n" ]
do
    echo -n "Body(y/n)? "
    read body
done
if [[ $body == 'y' ]]; then
    echo -n "Body: "
    read body
else
    body="Release of $version_number"
fi
​
​
if [[ $access_token == "0" ]]; then
    echo -n "Token: "
    read new_token
    sed -i "3s/.*access_token.*/access_token=$new_token/" release.sh
    access_token=$new_token
fi 
​
#echo curl -d '{"tag_name": "'"${version_number}"'","target_commitish": "'"${branch}"'","name": "'"${version_number}"'","body": "'"${body}"'","draft": false,"prerelease": '$prerelease'}' https://api.github.com/repos/cdt-baas/m2y_lib_android/releases?access_token=$access_token
curl -d '{"tag_name": "'"${version_number}"'","target_commitish": "'"${branch}"'","name": "'"${version_number}"'","body": "'"${body}"'","draft": false,"prerelease": '$prerelease'}' https://api.github.com/repos/cdt-baas/m2y_lib_android/releases?access_token=$access_token