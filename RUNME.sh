#!/usr/bin/env bash

BE='bundle exec'
RU='rvm'

RVM_ENVIR=/home/yebyen/.rvm/scripts/rvm
RUBY_VERS=3.1.1

 .  $RVM_ENVIR
$RU $RUBY_VERS >/dev/null
xvfb-run -s '+extension GLX +render -noreset' ./mohela.rb
