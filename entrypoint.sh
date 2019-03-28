#!/bin/bash
gem update bundler &&
bundle && bundle exec rackup --port 3000 --host 0.0.0.0