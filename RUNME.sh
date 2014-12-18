#!/usr/bin/env bash

BE='bundle exec'
RU='rvm'

RVM_ENVIR=/home/yebyen/.rvm/scripts/rvm
RUBY_VERS=2.1.2

 .  $RVM_ENVIR
$RU $RUBY_VERS
  ./mohela.rb
