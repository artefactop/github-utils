#!/bin/bash

# Call this each git push. Enabling this git hook is as easy as making the file executable.
# cp migrate-doc.sh .git/hooks/post-commit; chmod a+x .git/hooks/post-commit


echo "Migrates an existing doc folder into a gh-pages branch, and links back as submodule"
    
current_branch=`git branch | grep "^*" | sed -e "s/* //"`
repo=`git config --list | grep "^remote.origin.url" | sed -e "s/remote.origin.url=//"`
website_folder='doc'
tmp_folder="/tmp/gh-pages-website"
echo "Moving $website_folder folder to branch gh-pages."
echo "Working in $current_branch$ branch of $repo:"

rm -rf $tmp_folder
mv $website_folder $tmp_folder

echo "temporarily removing $website_folder whilst moving to gh-pages branch"
git commit -a -m "temporarily removing $website_folder whilst moving to gh-pages branch"
git symbolic-ref HEAD refs/heads/gh-pages
rm .git/index
git clean -fdx
cp -R $tmp_folder/* .
git add .
echo "Import original $website_folder folder from $current_branch branch"
git commit -a -m "Import original $website_folder folder from $current_branch branch"
git push origin gh-pages
git checkout $current_branch
git submodule add -b gh-pages $repo $website_folder
echo "migrated $website_folder -> gh-pages branch, and replaced with submodule link"
git commit -a -m "migrated $website_folder -> gh-pages branch, and replaced with submodule link"
git push
