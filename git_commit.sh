#!/bin/bash

set -e

# git folder
read DIR
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
	git commit -a "$MESSAGE"

	read -p "branch please: " BRANCH
	git branch -M "$BRANCH"

	# github authentication
	read -p "github username: "
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

	git remote add origin "$URL"
	git push -u origin "$BRANCH"

}


# ask exec
printf "will you exec script?(y|n): "
read ANSWER

case "$ANSWER" in
	[yY] | [yY][eE][sS]) 
		echo "confirmed. running script"
		return 0 ;;
	[nN] | [nN][oO]) 
		echo "canceled." 
		return 1 ;;
	*)
		echo "Invalid input"
		return 2 ;;
	esac

if [ $? -eq 0 ]; then
	git_exec
else
	echo "$?"
fi
