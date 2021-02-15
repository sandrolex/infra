#!/bin/bash

microstack launch --name master --flavor m1.large Bionic

microstack launch --name worker1 --flavor m1.medium Bionic
microstack launch --name worker2 --flavor m1.medium Bionic

