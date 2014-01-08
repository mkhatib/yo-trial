if [[ "$TRAVIS_BRANCH" == "" ]]
then
  echo "TRAVIS_BRANCH variable is empty. This util is only to be used by Travis CI."
  exit 1
elif [[ "$TRAVIS_BRANCH" != "master" ]]
then
  echo "Not master. No Deploy to do."
  exit 0
else
  echo "On master. Deploying now..."
  wget -qO- https://toolbelt.heroku.com/install-ubuntu.sh | sh
  git remote add web-client-heroku git@heroku.com:yo-trial-web-client.git
  echo "Host heroku.com" >> ~/.ssh/config
  echo "   StrictHostKeyChecking no" >> ~/.ssh/config
  echo "   CheckHostIP no" >> ~/.ssh/config
  echo "   UserKnownHostsFile=/dev/null" >> ~/.ssh/config
  heroku keys:clear
  yes | heroku keys:add
  yes | git push web-client-heroku `git subtree split --prefix web-client/dist master`:master --force
fi

if [[ "$TRAVIS_PULL_REQUEST" != "false" ]]
then
  echo "This is a pull request. No deployment will be done."
  exit 0
elif [[ "$TRAVIS_BRANCH" == "" ]]
then
  echo "TRAVIS_BRANCH variable is empty. This util is only to be used by Travis CI."
  exit 1
elif [[ "$TRAVIS_BRANCH" != "master" ]]
then
  echo "Not master. No Deploy to do."
  exit 0
else
  echo "On master. Deploying now..."
  wget -qO- https://toolbelt.heroku.com/install-ubuntu.sh | sh
  git remote add web-client-heroku git@heroku.com:yo-trial-web-client.git
  echo "Host heroku.com" >> ~/.ssh/config
  echo "   StrictHostKeyChecking no" >> ~/.ssh/config
  echo "   CheckHostIP no" >> ~/.ssh/config
  echo "   UserKnownHostsFile=/dev/null" >> ~/.ssh/config
  heroku keys:clear
  yes | heroku keys:add

  # Create a temp branch to deploy from.
  git checkout -b tmp-deploy
  # Un-ignoring dist for a second.
  sed '/web-client\/dist/d' .gitignore > .gitignore.new && mv .gitignore.new .gitignore
  cd $YO_HOME/web-client/ && grunt && cd $YO_HOME
  git add --all && git commit -a -m 'Dummy message.'
  yes | git push web-client-heroku `git subtree split --prefix web-client/dist tmp-deploy`:master --force
fi

