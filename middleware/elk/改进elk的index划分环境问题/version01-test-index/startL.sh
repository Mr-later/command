#!/usr/bin/env bash
#nohup ../logstash-5.6.0/bin/logstash -f ../conf/logstash_test.conf -w 10 -l ../logstash-5.6.0/logs/ &
nohup ../logstash-5.6.0/bin/logstash -f ../conf/logstash.conf -w 10 -l ../logstash-5.6.0/logs/ &
