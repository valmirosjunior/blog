#### Ruby on Rails Code Challenge

Project Requirements:

* Ruby version: 2.7.6

#### Before the code challenge:

* Clone the repository locally and install all the dependencies
* Get familiar with the codebase
* Check the database schema


#### How to Run
- docker compose build
- docker compose run web rails db:setup
- docker compose up
- open your browser at: [Project's root](http://localhost:3000)


#### Configure sending emails
- You need to create an app password through this [link](https://myaccount.google.com/apppasswords)
- Copy the .env.example to .env
- Then replace the values in the .env file

- OBS: It was tested using Gmail