#! /bin/bash

# first, install git and clone rbenv and rbenv-build
sudo yum install git -y
git clone https://github.com/sstephenson/rbenv.git ~/.rbenv
echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.bash_profile
echo 'eval "$(rbenv init -)"' >> ~/.bash_profile
git clone https://github.com/sstephenson/ruby-build.git ~/.rbenv/plugins/ruby-build

source ~/.bash_profile

# install ruby and bundler
rbenv install 2.1.4
rbenv global 2.1.4

gem install bundler
