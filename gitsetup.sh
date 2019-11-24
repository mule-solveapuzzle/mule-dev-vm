#/bin/sh

# Check if our github project is set up
response=$(curl --write-out %{http_code} --silent --output /dev/null https://github.com/mule-solveapuzzle/mule-dev-vm)

# Check status code
if [[ "$response" -ne 200 ]] ; then
  printf "mule-dev-vm repository has not been created - to create try this line \n curl -u 'mule-solveapuzzle' https://api.github.com/user/repos -d '{\"name\":\"mule-dev-vm\"}'"
  exit 1;
fi

# Check git & travis-ci are on path

# Check environment variables
if [[ -z $AWS_ACCESS_KEY_ID || -z $GITPW || -z $AWS_SECRET_KEY ]]; then	
  printf "Environment variables AWS_ACCESS_KEY_ID, AWS_SECRET_KEY and GITPW need to be set";
  exit 1;	
fi

printf "All env variables have values"

# Initialise repository

travis login --user npiper --github-token $GITPW
travis sync
travis enable


# Encrypt travis variables into .travis.yml
travis encrypt AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID --add
travis encrypt AWS_SECRET_KEY=$AWS_SECRET_KEY --add
travis encrypt GIT_USER_NAME=mule-solveapuzzle --add
travis encrypt GITPW=$GITPW --add
travis encrypt DOCKER_USERNAME=$DOCKER_USERNAME --add
travis encrypt DOCKER_PASSWORD=$DOCKER_PASSWORD --add
git add .travis.yml
git commit -m "Updated encrypted settings"
git push origin master


# Create 'develop' branch & push to repo
git branch develop
git checkout develop
git add .
git commit -m "adding a change from the develop branch"
git checkout master
git push origin develop

# create gh-pages branch
git checkout --orphan gh-pages
git rm -rf .
touch README.md
git add README.md
git commit -m 'initial gh-pages commit'
git push origin gh-pages

git checkout develop
