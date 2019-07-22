#!/bin/bash
access_token=efef76433f27e09568a91e58deaf025f295e45aa

tag_name_patch=3
tag_name_minor=2
tag_name_major=1

echo -n "Do you want to type the tag name? (y/n) "
read answer
while [ $answer != "y" ] && [ $answer != "n" ]
do
    echo -n "Do you want to type the tag name? (y/n) "
    read answer
done
if [[ $answer == "y" ]]; then
    echo -n "Major: "
    read tag_name_major
    echo -n "Minor: "
    read tag_name_minor
    echo -n "Patch: "
    read tag_name_patch
    sed -i "4s/.*tag.*/tag_name_patch=$tag_name_patch/" release.sh
    sed -i "5s/.*tag.*/tag_name_minor=$tag_name_minor/" release.sh
    sed -i "6s/.*tag.*/tag_name_major=$tag_name_major/" release.sh
else
    echo "p (Patch == + x.x.1)"
    echo "m (Minor == + x.1.x)"
    echo "mj (Major == + 1.x.x)"
    echo -e "Version upgrade?"
    read tag_increment
    while [ "$tag_increment" != "p" ] && [ "$tag_increment" != "m" ] && [ "$tag_increment" != "mj" ]
    do
    echo "p (Patch == + 0.0.1)"
    echo "m (Minor == + 0.1.0)"
    echo "mj (Major == + 1.0.0)"
    echo -e "Version upgrade?"
        read tag_increment
    done 
    if [[ $tag_increment == 'p' ]];then
        tag_name_patch=$(($tag_name_patch + 1))
        sed -i "4s/.*tag.*/tag_name_patch=$tag_name_patch/" release.sh
    elif [[ $tag_increment == 'm' ]];then
        tag_name_major=$(($tag_name_minor + 1))
        sed -i "5s/.*tag.*/tag_name_minor=$tag_name_minor/" release.sh
    else
        tag_name_major=$(($tag_name_major + 1))
        sed -i "6s/.*tag.*/tag_name_major=$tag_name_major/" release.sh

    fi
fi

tag_name=""$tag_name_major"."$tag_name_minor"."$tag_name_patch""

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
    echo -n "Access token: "
    read new_token
    sed -i "2s/.*access_token.*/access_token=$new_token/" release.sh
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
    echo "Closing..."
fi
