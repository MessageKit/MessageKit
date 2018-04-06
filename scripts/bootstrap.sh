#!/bin/sh

carthage bootstrap --platform ios
cp Cartfile.resolved Carthage
