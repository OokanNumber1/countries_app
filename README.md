# countries_app

# Description of the app
This is a mobile app that gets countries' detail from [Restcountries endpoint](https://restcountries.com/v3.1/all) and display them, upon clicking on a country tile, navigation to the detail's screen of the country tapped should happen, the following features are running :
- search among the countries (by name or capital).
- filter the countries to be displayed by continents and timezones.
- change to dark and light mode.

# Description of the codebase
The network call is done in the repository folder (country_repository.dart) in which List of Country is returned (Country is my model class) and the List returned is used to make the list of countries in the views/home.

Checking the width of the device to determine how the layout should be, is done at home_view.dart, home_mobile_screen has the layout for mobile (width less than or equal to 620px) and home_big_screen.dart has the layout for screens with width greater than 620px. The stated layout is the same for the detail's view.

# Description of libraries used
### Dio
This is used to make network call in the repository folder, I used it because it satisfies my need.
### flutter_riverpod
This is used to manage state (theme mode, list of countries from the network call) of the app and it was chosen because of the smooth way it does state management.

# Challenge faced
- Endpoint not having some fields in plain text,to get dialing code, one has to concatenate values of the root and suffix keys of idd, some fields has to be let go as I was not able to find a way around them (as with the dialing code).

# Probable features
- Making the app single paged : Not having to navigate to another screen to get detail of a country, there would be a kinda dropdown that shows important detail of a country upon tapped. One would also be able to see detail of more than one country at a time.

- [.apk link of the app](https://drive.google.com/file/d/1Wuk7MTQsF8TNtbMAgZmpmm9NmKO56OHg/view?usp=drivesdk)

- [Appetize Link](https://appetize.io/app/2tylw3nqsawbau4vj2lzouoluq)

