# Telegraph

Web server for which is capable of recieving rest calls and storing messages in morse inside a mongo database.

Deployed on heroku at the following uri: https://telegraph-rest-api.herokuapp.com/

## Curl commands
At the moment there is no front end implementation as such you can curl commands in order to interact with the different routes

* Signup
```bash
  curl -XPOST -d 'username=<Username>&password=<Password>&keybase=<Keybase Username>' 'https://telegraph-rest-api.herokuapp.com/signup'
 ```
* Login
```bash
 curl -XPOST -d 'username=<Username>&password=<Password>' 'https://telegraph-rest-api.herokuapp.com/login'
```
* View Public key of a user
```bash
curl -XGET -d 'user=<Username>' 'https://telegraph-rest-api.herokuapp.com/publickey'
```

* Logout 
```bash
curl -XGET 'https://telegraph-rest-api.herokuapp.com/logout'
```
* Send Message
```bash
curl -XGET 'https://telegraph-rest-api.herokuapp.com/send?user=<Username>&to=<To_Username>&sender_coded=<Message>&to_coded=<Message>'
```

## Future additions

We are currently looking into expanding our services to include morse code in the future


A Famingo© Labs Inc. product R&D division
