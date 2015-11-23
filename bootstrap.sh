#! /bin/bash

# first, install git and clone rbenv and rbenv-build
sudo yum install git readline-devel -y
git clone https://github.com/sstephenson/rbenv.git ~/.rbenv
git clone https://github.com/sstephenson/ruby-build.git ~/.rbenv/plugins/ruby-build

echo '' >> ~/.bash_profile
echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.bash_profile
echo 'eval "$(rbenv init -)"' >> ~/.bash_profile

source ~/.bash_profile

# install ruby and bundler
rbenv install 2.2.3
rbenv global 2.2.3

gem install bundler
