import flickrapi
import urllib
from PIL import Image

api_key = u'78dbab5121c5ca12910ef009bb1ae729'
api_secret = u'5285fbe72edd0d69'

flickr = flickrapi.FlickrAPI(api_key, api_secret, format='parsed-json')

keywords = ['dog', 'cat', 'red', 'blue', 'green', 'yellow', 'face', 'baby',
            'human', 'animal', 'sky', 'ocean', 'mountain', 'beach', 'rock',
            'flower', 'house', 'bee', 'orange', 'fruit', 'vegetable',
            'technology', 'speech', 'person', 'furniture', 'pet',
            'colorful', 'UNC', 'college', 'campus', 'camping', 'nature',
            'party', 'purple', 'tree', 'car', 'plane', 'boat', 'grass',
            'people', 'office', 'corporate', 'company', 'city', 'park',
            'camera', 'water', 'mural', 'group', 'protest', 'happy',
            'international', 'ship', 'young', 'old', 'tourist', 'village',
            'india', 'crowd', 'election', 'concert', 'phone', 'invention',
            'diversity', 'waterfall', 'casino', 'yellow', 'food', 'dish',
            'cuisine', 'tv', 'actor', 'song', 'fish', 'plant', 'leader',
            'rare', 'child', 'windy', 'rainy', 'sunny', 'religion',
            'desert', 'dessert', 'paper', 'building', 'individual',
            'creature', 'fantasy', 'fellow', 'being', 'customer', 'store',
            'pasta', 'girl', 'boy', 'woman', 'man', 'brown', 'pink']

photo_urls = []

for keyword in keywords:

    photos = flickr.photos.search(tags=keyword, per_page='100', extras='url_c')
    photo_dict = photos['photos']['photo']

    for photo in photo_dict:
        try:
            photo_urls.append(photo['url_c'])
        except:
            print('could not find url')

i = 0

for url in photo_urls:
    
    print(url)
    urllib.request.urlretrieve(url, f'corpus/photo{i}.jpg')
    image = Image.open(f'corpus/photo{i}.jpg') 
    image = image.resize((100, 100))
    image.save(f'corpus/photo{i}.jpg')
    i = i + 1



