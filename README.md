     _   __           _                         _   _   _ _       _       
    | | / /          | |                       | | | \ | (_)     (_)      
    | |/ /  ___ _   _| |__   ___   __ _ _ __ __| | |  \| |_ _ __  _  __ _ 
    |    \ / _ \ | | | '_ \ / _ \ / _` | '__/ _` | | . ` | | '_ \| |/ _` |
    | |\  \  __/ |_| | |_) | (_) | (_| | | | (_| | | |\  | | | | | | (_| |
    \_| \_/\___|\__, |_.__/ \___/ \__,_|_|  \__,_| \_| \_/_|_| |_| |\__,_|
                 __/ |                                          _/ |      
                |___/                                          |__/       

A multiplayer typing game build using Ruby on Rails, AJAX and jQuery.
Deployed at keyboardninja.herokuapp.com

## Installation
MySQL is used for development environment and Postgres for production. Hence to run locally:

1. Install all gems
    bundle install --without production
2. Setup database
    rails db:migrate RAILS_ENV=development
3. Run server
    rails server

## Tests
`rails test`

## Bugs and Issues
Have a bug or an issue with this template? Open a new issue here on GitHub.

## Copyright and License
Copyright Aditya Gajbhiye and Shikher Verma. Released under the MIT license.