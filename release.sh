#!/bin/bash
access_token=efef76433f27e09568a91e58deaf025f295e45aa

tag='v'
tag_name_major=1
tag_name_minor=2
tag_name_patch=3

repository_name=m2y_lib_android

if [[ $tag_name_patch == 'x' ]] && [[ $tag_name_minor == 'x' ]] && [[ $tag_name_major == 'x' ]]; then
    echo "Tag name: "
    echo -n "Major: "
    read tag_name_major
    echo -n "Minor: "
    read tag_name_minor
    echo -n "Patch: "
    read tag_name_patch
    sed -i "5s/.*tag.*/tag_name_major=$tag_name_major/" release.sh
    sed -i "6s/.*tag.*/tag_name_minor=$tag_name_minor/" release.sh
    sed -i "7s/.*tag.*/tag_name_patch=$tag_name_patch/" release.sh
else
    echo -n "Do you want to type the tag name? (y/n) "
    read type_tag
    while [[ $type_tag != "y" ]] && [[ $type_tag != "n" ]]
    do
        echo -n "Do you want to type the tag name? (y/n) "
        read type_tag
    done
    if [[ $type_tag == "y" ]]; then
        echo -n "Major: "
        read tag_name_major
        echo -n "Minor: "
        read tag_name_minor
        echo -n "Patch: "
        read tag_name_patch
        sed -i "5s/.*tag.*/tag_name_major=$tag_name_major/" release.sh
        sed -i "6s/.*tag.*/tag_name_minor=$tag_name_minor/" release.sh
        sed -i "7s/.*tag.*/tag_name_patch=$tag_name_patch/" release.sh
    else
        echo "mj (Major == + 1.x.x)"
        echo "m (Minor == + x.1.x)"
        echo "p (Patch == + x.x.1)"
        echo -e "Version upgrade?"
        read tag_increment
        while [[ $tag_increment != "p" ]] && [[ $tag_increment != "m" ]] && [[ $tag_increment != "mj" ]]
        do
            echo "mj (Major == + 1.0.0)"
            echo "m (Minor == + 0.1.0)"
            echo "p (Patch == + 0.0.1)"
            echo -e "Version upgrade?"
            read tag_increment
        done 
        if [[ $tag_increment == 'p' ]];then
            tag_name_patch=$(($tag_name_patch + 1))
            sed -i "7s/.*tag.*/tag_name_patch=$tag_name_patch/" release.sh
        elif [[ $tag_increment == 'm' ]];then
            tag_name_minor=$(($tag_name_minor + 1))
            sed -i "6s/.*tag.*/tag_name_minor=$tag_name_minor/" release.sh
        else
            tag_name_major=$(($tag_name_major + 1))
            sed -i "5s/.*tag.*/tag_name_major=$tag_name_major/" release.sh

        fi
    fi
fi


tag_name=""$tag""$tag_name_major"."$tag_name_minor"."$tag_name_patch""
echo "Version $tag_name"


echo -n "Target commitish: "
read target_commitish


echo -n "Name: "
read name


echo -n "Body? (y/n) "
read body
while [[ $body != "y" ]] && [[ $body != "n" ]]
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
while [[ $draft != "y" ]] && [[ $draft != "n" ]]
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
while [[ $prerelease != "y" ]] && [[ $prerelease != "n" ]]
do
    echo -n "Prerelease? (y/n) "
    read prerelease
done
if [[ $prerelease == "y" ]]; then
    prerelease=true
else
    prerelease=false
fi



if [[ $repository_name == 'undefined' ]]; then
    echo -n "Repository name: "
    read new_repository
    sed -i "8s/.*repository_name.*/repository_name=$new_repository/" release.sh
    repository_name=$new_repository
else
    echo -n "Do you want to change the repository? (y/n) "
    read change_repo
    while [[ $change_repo != "y" ]] && [[ $change_repo != "n" ]]
    do
        echo -n "Do you want to change the repository? (y/n) "
        read change_repo
    done
    if [[ $change_repo == 'y' ]]; then
        echo -n "Repository: "
        read new_repository
        sed -i "8s/.*repository_name.*/repository_name=$repository_name/" release.sh
        repository_name=$new_repository
    fi
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
    "repository name": '$repository_name'
}'   

echo -n "Do you want to confirm? (y/n): "
read confirmation
while [[ $confirmation != 'y' ]] && [[ $confirmation != 'n' ]]
do
    echo -n "Do you want to confirm? (y/n): "
    read confirmation
done
if [[ $confirmation == "y" ]]; then
    curl -d '{"tag_name": "'"${tag_name}"'","target_commitish": "'"${target_commitish}"'","name": "'"${name}"'","body": "'"${body}"'","draft": '$draft',"prerelease": '$prerelease'}' https://api.github.com/repos/cdt-baas/$repository_name/releases?access_token=$access_token
else
    echo "Closing..."
fi
