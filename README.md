# CSIT Mini Challenge 2023: Software Engineering (REST API)

A REST API written in Ruby on Rails for the [CSIT Software Engineering Mini Challenge 2023](https://se-mini-challenge.csit-events.sg/).

## Getting Started

To run this project, you will need the following:
* Ruby `^3.0.2`
* Rails `^7.0.6`

```bash
git clone
cd csit_rb
bundle install
bin/rails server
```

Alternatively, this project is also available as repository on Docker Hub. To run this project using Docker, you will need the following:
* Docker `^20.10.8`
* Docker Compose `^1.29.2`

```bash
docker pull shaunnope/csit-se-2023
docker run -p 3000:8080 shaunnope/csit-se-2023
```

## Extra Notes
The base app for this project was generated using the [Ruby on Rails](https://rubyonrails.org/) framework.
```bash
rails new csit_rb --api --skip-active-record
```

## Credits
With this being my first time developing a Rails app, I relied on the following resources to get started:
* [Rails Guides: Using Rails for API-only Applications](https://guides.rubyonrails.org/api_app.html)
* [RapidAPI: How to Build a RESTful API in Ruby](https://rapidapi.com/blog/how-to-build-an-api-in-ruby/)
* [Oliver DS: Creating a REST API with Rails](https://medium.com/@oliver.seq/creating-a-rest-api-with-rails-2a07f548e5dc)