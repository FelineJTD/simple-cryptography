Agak gila tiba-tiba pake Ruby but lesgooooo

# garis besar
ini pake Sinatra instead of Ruby on Rails, katanya sih lebih gampang dipelajarin soalnya buat app kecil. install ruby, install sinatra, terus run. kalo ga bisa, chatgpt :D

# setup:
1. install ruby https://gorails.com/setup/ubuntu/22.04
2. install sinatra
3. run `rerun ruby app.rb`

# note to self
- Gemfile is like package.json di react, isinya dependencies.
`bundle add [gemname]` buat nambahin gem

- APPARENTLY HRS <button type="button"></button> BARU JALAN LIKE WTF IT NEEDS TO SPECIFY THE TYPE IS BUTTON???!!

# how to do fe-be
- from the FE, call a function using js (public/js/whatever file you create for the function)
- then the js will do GET/POST to an API in app.rb
- the API will call a method from a model (models/whatever file you create for the method), don't forget to import this first di paling atas file app.rb
- the method will do the logic, and return the result to the API
- the API will return the result to the js
- the js can inject the response to the FE

chatgpt gives me the way with ajax and jquery, so I'm going with it.

## to debug
- use the console (console.log) to debug js (THIS PRINTS TO THE BROWSER CONSOLE)
- see the Network tab to look at specific errors when fetch fails (IN THE BROWSER)
- use puts in ruby (THIS PRINTS TO THE TERMINAL)

# TODO
- handle unprintable charas in extended vigenere
- handle file extension in extended vigenere
- add download as binary button