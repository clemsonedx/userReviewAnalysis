#!/bin/bash

apt-get purge openssh-{client,server} && apt-get install openssh-{client,server}
