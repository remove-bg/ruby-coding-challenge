# Image Cache

## Problem Summary

This problem involves writing some Ruby code to implement a filesystem base image cache.

### Expected time

45 minutes.

### Environment

- IDE and Ruby 3 environment. VSCode, IntelliJ or RubyMine free community versions work fine.
- [VSCode](https://code.visualstudio.com/)
- [IntelliJ](https://www.jetbrains.com/idea/)
- [RubyMine](https://www.jetbrains.com/ruby/)

### Background knowledge

Kaleido/Canva is a very visual product, there are lots of images involved. Many of our backend services
need to download these images and do something with them. For example, when downloading a design,
one of our backend services will download the image and store it on the filesystem while
processing the download. We’d like to avoid downloading the same image again and again, one
approach to this is to cache them.

Through the course of the interview, we'd like you to write some Ruby code that caches images
on the filesystem. The images are uniquely identified by urls.
