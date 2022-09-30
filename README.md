# Image Cache

## Problem Summary

This problem involves writing some Ruby code to implement a filesystem base image cache.

### Expected time

45 minutes.

### Competencies

- Basic Ruby coding skills
- Ability to synthesize requirements and turn those into code
- Understanding of files & IO
- Error handling
- Deterministic hashing and / or uuid generation
- Cache eviction strategies

### Environment

- IDE and Ruby 3 environment. VSCode, IntelliJ or RubyMine free community versions work fine.
- [VSCode](https://code.visualstudio.com/)
- [IntelliJ](https://www.jetbrains.com/idea/)
- [RubyMine](https://www.jetbrains.com/ruby/)

### Resources for candidate

Some starting code is provided.

### Background knowledge

> Kaleido/Canva is a very visual product, there are lots of images involved. Many of our backend services
> need to download these images and do something with them. For example, when downloading a design,
> one of our backend services will download the image and store it on the filesystem while
> processing the download. We’d like to avoid downloading the same image again and again, one
> approach to this is to cache them.
>
> Through the course of the interview, we'd like you to write some Ruby code that caches images
> on the filesystem. The images are uniquely identified by urls.

### Likely clarifying questions:

Q: How much disk space is there?

> A:
> The instances have very large disks. For the purposes of this interview, you can consider the
> instances to have infinite disk capacity. If there is time at the end, we can chat about how we
> might implement a cache that can take disk capacity into consideration.

Q: Does every url have a unique image? Are there duplicate images?

> A:
> No, we can consider a unique url to represent a unique image. We are not concerned with the binary
> content of individual images. We are also not concerned if two different urls reference identical
> image content, in this case we will still save two images on the filesystem. If there is time at
> the end, we can chat about how we might implement a cache that can take duplicate images into
> consideration.

Q: Is there any authentication on the urls?

> A:
> For the purposes of the interview, we can assume that we are able to access all image urls.

Q: What sort of cache-eviction strategy should be used?

> A:
> We will take a look at the code in a minute where the requirements are described in the comments.
> We will initially use a simple lease / release mechanism, but if there is time at the end, we can
> discuss different cache-eviction strategies.

## Session outline

Step 1: Brief walk through the code
Step 2: Implement lease
Step 3: Implement release

All candidates are expected to complete all steps. Better candidates might finish quickly and then
there may be time for additional questions.

### Step 1: Brief walk through the code

Let the candidate open up their IDE and get oriented with the code.

> Open up your IDE and take a look at caches.py. There is an ImageCache class with a lease and
> release method. This the class that we would like you to implement during the interview.
>
> Take a few minutes to read through the comments. Let me know if you have any questions or if
> something isn't clear.

Answer any clarifying questions the candidate might have, but don't let them get too stuck on the
details just yet. Opening up the tests often can be helpful to clarify the requirements.

> Lets take a look at the tests inside tests.py. There are 3 tests. Lets run them quickly. They
> should all fail. If you can get all 3 tests passing, it is a good sign that you are on the right
> track.
>
> Let’s just take a look at the first test. You can see that we are leasing the same image twice.
> And we are asserting that we only need to download the image once, because it is being cached.
>
> Take a look at the other 2 tests to confirm your understanding of the problem.

Again, answer any clarifying questions the candidate may have before showing them files.py

> Take a look at files.py. This is only here for your convenience. There are a few helpful
> utilities for working with files. You don't need to use them.

#### Levelling

- B1: there is no expectation for B1 to ask any clarifying question.
- B2: disk space and some understanding of constraints on the excercise, how do we store the cache?
- B3: question around understanding constraints, some knowledge about how a cache works

### Step 2: Implement lease

> Ok, lets get started on the implementation! Feel free to use Google and ask more clarifying
> questions as you progress.

The candidate should now begin their implementation.

Some things to note:

- If the candidate asks about ImageClient (or image_client) explain that they don't need to
  implement any HTTP requests to fetch images. The ImageCache is provided for explanatory purposes
  and is mocked out in the tests. Hopefully, they are familiar with IoC or dependency injection.
- Using a hard-coded location such as "/tmp" to store images is acceptable and makes it easy to
  debug issues. Instead of a hardcoded location, the base path for downloaded images can also be
  injected into the constructor.
- The candidate should realise that they need a unique name for each file that is downloaded. They
  should hopefully also realise that the image’s URL is a good candidate for a unique name if it
  wasn’t for the special characters used. Ideally, a candidate would encode or hash the url so it is
  safe to use as a filename. Other solutions might include mapping URL to some unique id.
- A good candidate should recognise that exceptions can occur in the implementation. If a candidate
  provides a solution without error handling, ask them where they think exceptions can happen and to
  add some error handling. ImageCacheException is provided Exception for the candidate to use.
- If the candidate runs the tests after implementing lease, the first two tests should probably be
  passing.

Once lease is implemented and you are satisfied, move on to the implementation of release.

#### Levelling

- B1: no additional expectations apart from passing the interview.
- B2: unique id generation and url/mapping, interface usage -> being familiar enough with dependency injection, error handling (not implementing exceptions in particular, but having a discussion around errors)
- B3: edge cases, performance considerations
- C1: B3 same expectations as B3
- C2: B3 same expectations as B3

### Step 3: Implement release

> Now let's implement release!

Implementing release is normally straightforward after implementing lease. Even if the candidate
didn't realise they need to keep a counter of some sort for the leases to know when to delete the
images.

Some things to note:

- If the candidate recognises that it might be a poor implementation to delete files synchronously
  during the release (it might be better in reality to delete them asynchronously), agree, but explain
  that we want the naive implementation for the purposes of the interview.
- The candidate should realise that well-behaved clients should not call release before lease and
  that it indicates an error condition. If not, raise this topic and ask them to add some error
  handling. A good candidate might also add a test for this.

#### Levelling

- B1: no additional expectations apart from passing the interview.
- B2: after changing release they should change lease if necessary without additional prompting
- B3: tests are running, notice that you need some sort of counter (multiple clients), add more tests
- C1: B3 same expectations as B3
- C2: B3 same expectations as B3

### Bonus discussion questions

These are some deeper discussion questions to get further signals:

- The current implementation of the cache is a bit naive and some images are leased again shortly
  after they have been released. This causes extra downloads to occur. Is there a way we can keep an
  image in the cache, even if no one holds a lease? Note: Now is a good time to discuss [cache
  eviction strategies](https://en.wikipedia.org/wiki/Cache_replacement_policies).
- If it didn't come up during the implementation, point out the image_client in the constructor of
  ImageCache and ask them if the candidate recognises the pattern. Dependency Injection. Discuss why
  it is useful.
- What can we do to ensure that the cache is warm after a restart occurs? The simple solution is
  to traverse the directory where cached files are stored and loading the cache up with those files.
  How might one know which file maps to which url?
- How might we design the cache if the file system has limited space. What implications does this
  have? This should raise questions like "What should we do when there is no more space left to
  download?". Throwing an exception is fine here.
- How might we design the system if we want to optimise for filesystem space by de-duplicating
  images? Possibly content-address the cache by hashing the file contents. What are the pros vs cons?
