[![Build Status](https://travis-ci.org/RxSwiftCommunity/RxCache.svg)](https://travis-ci.org/RxSwiftCommunity/RxCache)

RxCache
=======

This library is used with [RxSwift](https://github.com/ReactiveX/RxSwift) to provide a generalized cache abstraction.

__MORE DESCRIPTION HERE__
	
Usage
-----

```swift
final class ViewModel {
	
	// allocate a cache with a given lifetime
	private let autocompleteCache = Cache<[Prediction]>(name: "predictionCache", storage: .inMemory())

	// the function we want to cache
	func callServer(with input: String) -> Observable<[Prediction]> {
		return ... // for example call the server
	}

	// the domain function
	func predictions(for input: String) -> Observable<[Prediction]> {
		return callServer(with: input)
			.cached(in: autocompleteCache, forKey: input) // use the cache operator
	}
}
```

The cache operator will query the given cache and if the value is found it will be returned along the pipeline.
If no value is found in cache, the original observable (here `callServer`) will be subscribed and result will be sent to the cache before continuing through the pipeline.

The Cache class pools and reuse requests when possible independently of its backend storage. For example here, if `predictions` is called with high frequency with the same key, only one subscription will be made and all requests to the cache will wait for this subscription to finish to return the value.

The cache class is independent of the storage it is constructed with. Which means that you can use either memory, disk, network or whatever storage you want by creating a CacheStorage instance.

CacheStorage can be composed before being used by one or multiple cache. For example you could create a image cache for downloading image which will use a few megabytes in memory and compose it with a disk cache to store images for a few weeks. When a cache is composed, the caches are queried in nearest to furthest order and the first value found is returned. If a value is found, all nearest cache are proposed to cache the value to allow a faster access.


Installing
----------

Just add the line below to your Podfile:

```ruby
pod 'RxCache'
```

Then run `pod install` and that'll be 👌

Developer instructions
----------------------

If you wish to contribute to RxCache, first clone this repository then bootstrap the dependencies with [Carthage](https://github.com/Carthage/Carthage#installing-carthage):

```shell
carthage bootstrap
```

Before making changes, we encourage you to check out [issues](https://github.com/jeremiegirault/RxCache/issues) and discuss proposed changes with the team, to avoid duplicate work. Once you're done making your changes and adding tests for them, please open a [pull request](https://github.com/jeremiegirault/RxCache/pulls).

Thanks
------

Florent Pillet

License
-------

Written by Jérémie Girault.
This library belongs to _RxSwiftCommunity_.

RxCache is available under the MIT license. See the LICENSE file for more info.

![Permissive licenses are the only licenses permitted in the Q continuum.](https://38.media.tumblr.com/4ca19ffae09cb09520cbb5611f0a17e9/tumblr_n13vc9nm1Q1svlvsyo6_250.gif)
