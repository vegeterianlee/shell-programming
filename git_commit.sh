#!/bin/bash

set -e

# git folder
read -p "Enter target git directory: " DIR 
cd "$DIR"

# script fun
git_exec(){
	dnf -q -y install git-core

	# git
	git init
	git config --global user.name "vegeterian"
	git config --global user.email "max322318@gmail.com"
	git config --list	
	git add -A

	read -p "Commit message: " MESSAGE
	git commit -m "$MESSAGE"

	read -p "branch please: " BRANCH
	git branch -M "$BRANCH"

	# github authentication
	if [[ $(git remote -v | wc -l) -ge 1 ]]; then
		git push -u origin "$BRANCH"
		exit 0
	fi

	read -p "github username: " GITHUB_USER
	read -s -p "GitHub personal access token: " GITHUB_TOKEN
	echo

	while true; do		
		read -p "github repo URL(without https://): " REPO_URL
		if [[ "$REPO_URL" == https:* ]]; then
			echo "ERROR URL"
		else
			break
		fi
	done

	URL="https://$GITHUB_USER:$GITHUB_TOKEN@$REPO_URL"
	if [[ $(git remote -v | wc -l) -ge 1 ]]; then
    	git remote set-url origin "$URL"
	else
   		git remote add origin "$URL"
	fi

	git push -u origin "$BRANCH"

}


# ask exec
printf "will you exec script?(y|n): "
read ANSWER

case "$ANSWER" in
	[yY] | [yY][eE][sS]) 
		echo "confirmed. running script"
		;;
	[nN] | [nN][oO]) 
		echo "canceled." 
		exit 1 ;;
	*)
		echo "Invalid input"
		exit 2 ;;
	esac

if [ $? -eq 0 ]; then
	git_exec
else
	echo "$?"
fi
