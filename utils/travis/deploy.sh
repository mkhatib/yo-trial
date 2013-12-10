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
  yes | git subtree push --prefix web-client/dist web-client-heroku master
fi
