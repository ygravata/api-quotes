# README

## Overview
This project is an API built using Rails, accessed through token authentication, that web scraps some information from [this quotes website](http://quotes.toscrape.com), and returns the info extracted through an API. 


### Specifications bellow:

* **Rails (rails 6.0.3.2)**;
* **Ruby (ruby 2.6.6)**
* **mongoid (7.1.2)** - database;
* **devise (4.7.2)** - for user authentication;
* **simple_token_authentication (1.17.0)** - for token authentication;

### Configuration
#### Cloning repository:
```
git clone git@github.com:ygravata/api-quotes.git --origin api-quotes your-project-name
cd your-project-name
```
#### Create your repository:
```
git init .
git add .
git commit
````
#### Install all the dependencies:
```
bundle install
```

```
yarn install
```

#### Run MongoDB Locally:
As MongoDB server is running locally, if you don't have already a local MongoDB server, [download and install](https://docs.mongodb.com/manual/installation/).
The configuration at config/mongoid.yml and config/cable.yml needs to be changed (replace the api_quotes between asterisks, removing the asterisks, with your app name):
  
* config/mongoid.yml:
```
- config if you want
development:
  clients:
    default:
      database: *api_quotes*_development
      hosts:
        - localhost:27017
      options:
        server_selection_timeout: 1
 ```
 ```
test:
  clients:
    default:
      database: *api_quotes*_test
      hosts:
        - localhost:27017
      options:
        read:
          mode: :primary
        max_pool_size: 1
 ```
 
 * config/cable.yml
  ```
production:
  adapter: redis
  url: <%= ENV.fetch("REDIS_URL") { "redis://localhost:6379/1" } %>
  channel_prefix: *api_quotes*_production
 ```
 
* If you recently installed MongoDB (for ubuntu), and need to start the service*:
```
sudo service mongod start 
```
*Always be cautious when using 'sudo' command;
        
### Understanding the API:

#### Overview:

* This API will web scrap for quotes on the website http://quotes.toscrape.com/ and the resulting information will be recorded in the MongoDB and made avaiable by the API itself.
* ThIS API receives a "tag" as parameter (ex: http://quotes.toscrape.com/word), and the quotes to be extracted must be classifed according to this "tag";
* Everytime the API begin a new scraping, will check before with MongoDB, to see if the said "tag" already been searched. If so, the info already in MongoDB will be displayed;

This API has the following endpoints and structures:

* To see tag results: */api/v1/quotes/:search_tag*:
```         
{
    "quotes": [
        {
            "quote": "quote",
            "author": "author name",
            "author_about": "link to author profile",
            "tags": [
                {
                    "tag1": "tag1"
                },
                {
                    "tag2": "tag2"
                 }
             ]
        }
    ]
}
```

* To see authors and respectives quotes already saved into MongoDB: */api/v1/authors*:
```         
{
    "authors": [
        {
            "author": "Author name",
            "author_about": "link to author profile",
            "quotes": [
                {
                    "quote": "quote"
                }
         }
    ]
}
```
#### How to use:

You can use:
* Postman: see [this tutorial](https://www.guru99.com/postman-tutorial.html) to learn how to use;
* Console (as bellow);

Access the terminal:
```
rails c
```
Create a user:
```
User.create(email: "your@email.com", password: "123456")
```
This will generate something like that:
```
 #<User _id: BSON::ObjectId('5f37339b954d1751ac7a191b'), authentication_token: "Yc_QXEcq44VaFYQ3Aq9t", email: "your@email.com">
```
Copy the 'authentication_token' and use as bellow to run the API:

* For /api/v1/quotes/:search_tag endpoint (with "word" as the tag to be searched):
```
curl -i -X POST                                        \
       -H 'Content-Type: application/json'              \
       -H 'X-User-Email: your@email.com'               \
       -H 'X-User-Token: Yc_QXEcq44VaFYQ3Aq9t'          \
       http://localhost:3000/api/v1/quotes/word
```

* For /api/v1/authors endpoint:
```
curl -i -X GET                                        \
       -H 'Content-Type: application/json'              \
       -H 'X-User-Email: your@email.com'               \
       -H 'X-User-Token: Yc_QXEcq44VaFYQ3Aq9t'          \
       http://localhost:3000/api/v1/authors
```
### Notes:
* This API was created with a versioning structure (as "app/controllers/api/v1/quotes_controller.rb"), as a webscraper needs to be constantly changed (depending on changes of the scraped website structure);
* This allows the API to be continuously developed and changed, without changing the behaviour of earlier versions, avoiding affecting different clients;
* As the models aren't versioned, this API was built setting the scrapping methods into the controller.;
* This way, any future change in the scraping method of new versions of the API won't affect earlier versions;
#### Next steps:

* Replace "SearchTag" model relations with "Quote" for "Tag" relations with "Quote";
  * "Tag" will receive a boolean field, that indicates if the object was already searched or not;
  * This will allow that the field "tags" (type array) of "Quote" be replaced for a relation "has_and_belongs_to_many" with "Tag";
  * This way the API can receive a endpoint to consult all the tags in the MongoDB (no matter if they were searched or not), and its respectives quotes;
* Set a index for all the classes, so the performance of the app improves;

## Thank you!
