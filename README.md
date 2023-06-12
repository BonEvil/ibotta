# ibotta

## Structure
This application contains no storyboards or nib/xib files. All views (including the initial view) are created programatically.

The View Controllers are encapsulated in a generic ```UINavigationViewController``` which is set as the ```window.rootViewController``` for the application.

### OffersCollectionViewController
The ```UINavigationController.rootViewController``` is set as an instance of ```OffersCollectionViewController```. This controller’s cell layout is per the mock view included with the instructions. The cells are of type ```OfferCell``` and are set up according to the mock view as well.

### OfferDetailViewController
This controller’s layout consists of the title being the offer’s current value.

There is an image view with a fixed height that also contains a button to set this offer as a favorite.

Text under the image consists of a label for the product name, label for the product details, and a label for the terms of the offer.

### Image Caching
Images are cached as they are loaded. There is an arbitrary cache limit of 50 images. Once this limit is reached, each time an image is appended to the cache, the first image is popped off to keep the limit.

When trying to cache an image, the cache first checks to see if the image already exists in order to not duplicate cached images.

The image in ```OfferCell``` first tries to load from the cache. If the image does not exist, it then loads from the provided URL and caches the image.

The image in ```OfferDetailViewController``` is loaded from the cache every time as it is guaranteed to be there because the navigation to it comes from an ```OfferCell``` that is visible on the screen which would have a cached image or just cached an image.

Tapping on the “star” image will set this offer as a favorite and will be reflected on both the cell and detail UI.

### Favorites
The favorite offers are currently only stored ephemerally so they will disappear if the application is moved from memory. This can be changed to persisted either by storing locally in Core Data or by executing a service call to store in a remote user record.

## 3rd-Party dependencies
I use the term ‘3rd-party’ here somewhat loosely. This dependency is actually my own open-source project.

#### BuckarooBanzai
This is a networking layer that I created and have updated to use modern concurrency idioms. The documentation is not complete as I have only recently been able to start detailing its use. Feel free to look it over as well as part of how I design projects.

https://github.com/BonEvil/BuckarooBanzai
