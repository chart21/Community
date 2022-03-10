# Prerequisites: #


## 1. Install Flutter: ##

Connect your phone to a PC having flutter and required dependencies installed: https://flutter.dev/docs/get-started/install
Set up flutter for VSCode: https://flutter.dev/docs/get-started/editor?tab=vscode
Run a test App: https://flutter.dev/docs/get-started/test-drive?tab=vscode (as Community runs for both Android and iOS you should get the test app running ideally on both platforms)



-> you completed all steps successfully if flutter opened a counter app on your phone and you can increase the counter manually

Recommended VSCode Packages:
Flutter
Awesome Flutter Snippets
Bracket Pair Colorizer 2


## 2. Get a Google Maps API Key ##

Create a new project and get an API Key for at least Maps Android, Maps iOS, Places and Directions (you will have one key for all maps services, just activate everything as there are no additional costs)
https://www.webtimiser.de/google-maps-api-key-erstellen/ (German guide)
https://developers.google.com/maps/gmp-get-started (official guide)



# Start-up Guide: #


## Folder Configuration: ##


1. open AndroidManfiest.xml (app/src/main/)
	enter your Google Maps API key in line 21

2. open AppDelegate.m (ios/Runner/)
	enter your Google Maps API key in line 9

3. open config.dart (lib/)
	type in your Google Maps API key, optionally replace blockchain URL and contract address if you deployed those somewhere else
	
4. if you want to compile on a physical iOS Device:
	5.1 open project in Xcode and select runner
	5.2 give a unique Display name and bundle identifier to the project
	5.3 Select your Development Team (if you dont have one create an apple id and register as an developer at https://developer.apple.com/  -> account)
	5.4 After compiling the app with XCode open setting on your iOS device to trust the selected Development team https://testersupport.usertesting.com/hc/en-us/articles/115003712912-How-to-Trust-an-Unreleased-iOS-App 




## Start the app ##
type flutter pub get in a console at folder level (if it does not get a connection, make sure proxy is set in your terminal)

flutter run

Note that on emulators you need to have the right proxy settings for any internet connection and therefore the map and place search dependencies to work.
Make also sure your Google Maps API Key is activated for at least iOS Maps, Android Maps, Places API, Routes API 
If the app starts and searching places as well as the map view works, you are all set. You should have internet connection and optionally GPS activated.


For learning Flutter I recommend this free course: https://www.udacity.com/course/build-native-mobile-apps-with-flutter--ud905



# App functionalities and relevant code #
Important: Please not that you can only reserve rentals if the following conditions are met: User is signed in, user is a verified renter for the desired rental object, user has minimal balance threshold, user has not already an actively reserved rental at the moment
Watch the demo video in the media folder for a more visual impression.


### Home Screen ###
The Home Screen is the main screen after opening the app and shows the Google Map with markers, icons and buttons on top

1. Swipe Right/press menu button -> open Drawer (Sidebar)

	Required Action: On the home screen either swipe right from the left edge of the screen or press the menu button on the top left
	
	Result: Opens Drawer -> go to Drawer Section for more details
	
		Relevant Code: myDrawer.dart (defines the drawer), home.dart (defines linking with swiping and menu button press)
	
	
	
2. Swipe Down -> Refresh Map

	Required Action: On the home screen swipe down from the top of the screen
	
	Result: Reloads the map (can be used to add newly added rentals to the marker on the map)
	
		Relevant Code: myMap.dart -> RefreshIndicator Widget
	
	
	
3. Swipe left/press filter button -> Open Filter

	Required Action: Swipe left around the button right icons of the home screen to show the filter 
	
	Result: Filter will show up and allows to display or no longer display certain object types (charging stations, cars, ..)
	
		Relevant Code: WholeButtomView.dart (defines button and swiping), slideRightRoute, slideTransition.dart (defines the fly in from right animation), myFilterCheckBox.dart (defines filter and state changes)



4. Swipe Up/press the Schedule button next to the TextField
	
	Required Action: Swipe Up from the bottom of the screen or press the Schedule button next to the TextField
	
	Result: Schedule with Datepicker will show up to look for future rentals, close it by swiping down or pressing the Schedule button again
	
		Relevant Code: home.dart (_showBottomSheet section), WholeBottomView.dart (for linking when user presses schedule button), datepicker.dart (For selecting date and time within the datepicker)



5. Press on the Textfield
	
	Required Action: Press on the Textfield 'Set Pickup Address' on the bottom of the screen
	
	Result: Opens a search for any place the user wants the map to navigate to
	
		Relevant Code: bottomUserFormField.dart



6. Press on the GPS icon
	
	Required Action: Press on the Location bottom at the button of the screen
	
	Result: Moves the map to user location once the location.dart dependency is installed (https://pub.dev/packages/location will give proxy errors in BMW environment) 
	
		Relevant Code: home.dart





#### Google Map ####
The Google Map is part of the home screen and shows markers with each offer from the Blockchain



1. tab anywhere
	
	Required Action: Tab anywhere on the map where no marker is located
	
	Result: Resets the zoom level to a comfortable spot for the user to have a good overview in a reasonable range (faster than zooming in and out manually), closes any opened BottomModalSheet
	
		Relevant Code: myMap.dart



2. tab on a marker
	
	Required Action: Tab on any marker of the map (not all icons are optimized for markers, press on the bottom section of the marker icon in case of problems)
	
	Result: moves the Map to center the marker, may zoom in and out to give overview over object drop off polygons, zooms to an appropriate level for the user, opens a BottomModalSheet with offer information and reserve options, swipe down or tab anywhere on the map to get rid of it
	
		Relevant Code: myMap.dart



3. Use finger navigation
	
	Requried Action: Zoom or move or rotate your finger on the map just as with any map application
	
	Result: navigates thorugh the map manually as expected
	
		Relevant Code: myMap.dart
	
	




#### BottomModalSheet ####
The BottomModalSheet is a non-persistent modal sheet which opens from the Bottom after the user tabs on a map marker or tabs the clock of a started or reserved rentals on the right. It reveals rental information and allows the user to reserve, cancel, start or end rentals.


1. Swipe down/tab anywhere
	
	Required Action: Tab anywhere on the map where no marker is located, or swipe down the Sheet
	
	Result: Closes the Sheet, if the displayed rental is reserved or started shows a clock at the bottom right of the screen
	
		Relevant Code: bottomMarkerModalSheet.dart, (slideClockAnimation.dart)



2. Press Reserve button
	
	Required Action: If the rental offer is not reserved or started at the moment tab the reserve button on the bottom of the Sheet
	
	Result: Reserves the rental offer and starts the rental clock on the right of the screen if the following conditions are met: User is signed in, user is a verified renter for the desired rental object, user has minimal balance threshold, user has not already an actively reserved rental at the moment, otherwise does nothing
	
		Relevant Code: bottomMarkerModalSheet.dart



3. Press Cancel Reservation button
	
	Required Action: If the rental offer is reserved but not started at the moment tab the Cancel reservation button on the bottom left of the sheet
	
	Result: Cancels the reservation of the rental and allows the user to reserve a new rental offer
	
		Relevant Code: bottomMarkerModalSheet.dart



4. Press Start Rental Buttom 
	
	Required Action: If the rental is reserved but not started at the moment tab the Start Rental bottom on the bottom of the sheet
	
	Result: Starts the rental, activates the rental clock and allows the user to reserve a new	rental offer
	
		Relevant Code: bottomMarkerModalSheet.dart



5. Press Reservation clock icon
	
	Required Action: Tab reservation clock icon when the Sheet is closed
	
	Result: Opens the Sheet and navigates the map center to the reserved rental 
	
		Relevant Code: bottomMarkerModalSheet.dart, slideClockAnimation.dart



6. Press Rental clock icon
	
	Required Action: Tab rental clock icon when the Sheet is closed
	
	Result: Opens the Sheet and navigates the map center to the started rental
	
		Relevant Code: bottomMarkerModalSheet.dart, slideClockAnimation.dart



7. Press end rental button
	
	Required Action: Tab end rental button on the bottom of the sheet to end a started rental
	
	Results: Gets confirmation from the vehicle and opens a Review Page
	
		Relevant Code: bottomMarkerModalSheet.dart



### Drawer ###
The drawer is a sidebar with further navigation for the user that opens if the user tabs the menu button or swipes right on the edge of the left screen on the home screen.



1. Swipe left:
	
	Required Action: Swipe left anywhere on the screen
	
	Result: Closes the Drawer
	
		Relevant Code: myDrawer.dart
	
	
	
	
2. Press on Drawer buttons
	
	Required Action: Tab on any drawer icon 
	
	Result: Navigates the user to the described Screen
	
		Relevant Code: myDrawer.dart



3. Press on Verified Lessor/Verified Lessor icon section

	Required Action: If signed in, tab on the displayed information on the top of the drawer

	Result: Navigates the user to the Verification Screen

		Relevant Code: myDrawer.dart



4. Press on Balance

	Required Action: If signed in, tab on the displayed information on the top of the drawer

	Result: Navigates the user to the Payment Screen

		Relevant Code: myDrawer.dart



	
#### Sign-in/Register Screen ####

The Sign-in/Register Screen pops up once the user tabs on the respective buttons on the drawer. Tabbing on Sign in or Register button logs in a demo user.

Relevant Code: logInPage.dart, registerPage.dart

#### Review Screen ####

The Review Screen is a rental summary page that shows up if a rental is finished and allows the user to rate the lessor and/or send a report. Functions should be self-explanatory.

Relevant Code: review.dart, property.dart (links star rating to state), starrating.dart


### Further Screens ###


1. Offer Service Screen: Allows user to offer a rental to the Community Platform 

		Relevant Code: offerService.dart, datePickerOffer.dart (for earliest and latest rental date and time)

2. History Screen: Shows a history of user rental and offered rentals of the user (not yet implemented)

		Relevant Code: history.dart

3. Verifiaction Screen: Shows a summary of verified rental and leasing objects with the option to upload documents to a desired verifier or use account linking for further verification

		Relevant Code: verification.dart, verifierSelection.dart

4. Payment Screen: Show balance and options to add or withdrawal balance

		Relevant Code: payment.dart

5. Settings Screen: Can backup private key in the future to enable or disable further settings

		Relevant Code: settings.dart

6. Help Screen: Can provide further helpful information in the future 

		Relevant Code: help.dart

### Next development steps ###

The next development steps are mainly adding Blockchain call and sending transactions, local File read/writes for keystore, password and user data management, third party integration for account linking (register, login), off-chain document upload (verification), payment integration

All steps are further described and should be implemented in the following files (files below are also in recommended order):

registerPage.dart

logInPage.dart

state.dart

myMap.dart

bottomMarkerModalSheet.dart

home.dart

review.dart

offerService.dart

settings.dart

payment.dart

verification.dart

(history.dart)
  

### Solving proxy issues

If you are behind a firewall and need a proxy, you also need these commands to compile the app:

1. open gradle.properties (android/gradle.properties)
	enter your credentials for http and https proxy (if needed)

2. Sometimes, if it still gives gradle errors you have to add gradle to your path and execute gradle -Dhttp.proxyHost=<proxy Address> -Dhttp.proxyPort=<proxy port> -Dhttp.proxyUser=<proxy Username> -Dhttp.proxyPassword=<proxy password> in terminal)

3. If the compiling process successfully installs all the dependencies but the app still crashes before starting, the permission handler might be a problem. Open the main.dart (lib/) file and delete line 5, 9-11, 23-29 (all lines associated to permission handler,
additionally you might want to delete permissionHandler in pubspec.yaml)