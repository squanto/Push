# Goal
Make it really easy to podcast / livestream audio.


To do this, I'm following the path of different use cases for the app, and building features in the order that users would experience them.
# Spec
Push-to-talk audio. 

Mirror the Twitter iOS app, but with audio instead. Diverge accordingly.  

1. Modify login to copy twitter's web login.
	- Remove twitter auth(??), add email auth and auto-parse verification. 
2. Make it hold to record + send to parse in the background as I send metadata (Instagram interview style). (check)
	- Send to parse. Associate it with the logged in user. (check)
4. Be able to 'log in' to someone's channel
	- Create a table (Follow Table), with a following user and followed user. 
5. Get files as they're recorded to parse and play them. 

6. Modify record button to take files as they're recording, piece them out, and send them to parse. 

7. There's a setting to connect your twitter and let it scan for people you follow to follow here (two simple pfqueries + custom twitter auth).
	- It automatically scans and 'follows' people you already follow on twitter. ( or gives you the option?)
	- Add them as a tabl view (http://24.media.tumblr.com/tumblr_m2qlr7H9Yk1qzff5uo2_1280.png).
	- https://parse.com/docs/ios_guide#twitter-users (this)

8. Interact with the (backbone.js / rails) Web App. (Learn javascript with parse?)
	- Start off with the landing screen. Check out: (http://www.blip.me/broadcast/).


# TODO:
- Add github pages project page (with minimal theme: https://github.com/orderedlist/minimal) (Check)

- Add settings for updating / adding email, reseting passwords, etc.
	
1. Make pretty.
- Fix images / icons for retina display (check)
- Fix Splash logo for retina display
- Add Page control the first time you sign up.

- Add email confirmation / authdata


Add find people to follow, startup guide, etc. to sidescrolling splash screen.

http://www.cocoacontrols.com/platforms/ios/controls/center-button-in-tab-bar
// add this center button to the record functionality (look at anypic source code?).

http://www.cocoacontrols.com/platforms/ios/controls/pull-to-refresh-tableview

http://idevrecipes.com/2011/04/14/how-does-the-twitter-iphone-app-implement-side-swiping-on-a-table/
// swipe controls on 

- Go back and make sure all delegate declarations are in teh view did load function.
- I'll probably have to abstract the view within the me view controller to be able to use all of the same elements with other people's profiles. 

# Ned Notes
## Questins
- Record, stop, and send? or hold to record?
- How best to add options to a recording. 
- Loading my Tab bar items where I load them. 
- Record VC.m, line 100-110.
- Discover functionality. (?!?)
	- How does search do its animation to a search view controller. 
	- Add search to table view (??)
	- Add Diretions for geotagged sounds (like a virtual tour throughout a city).
- discovery VC line 40-50.
- Sliding UITableView while first responder is selected. 
- Sending the file in the background as users update metadata (??)
- Parse one to many relationships. 
- Parse many to many relationships (hashtags).

-http://stackoverflow.com/questions/409259/having-a-uitextfield-in-a-uitableviewcell (??)
- Swipe the table to the left for options on recordings (??).
- How to organize recent searches (as it's own table in Parse with User => search => timestamp)(??).
- Search Discovery View Controller. 

- Use core animation to swap the view of each tableviewcell. There's probably two views layered on top of each other, with a view animation, set the opacity to 0, and when it comes back, it can respond to touch events. 

- Updating a user profile with a profile photo.
Line 162, Signup view controller. 

- How to totally turn off being able to rotate an application.

- How to safely rename a file (DashboardViewController => TabBar Controller)?

- How to make a custom table view with custom cells for 

## Notes

### Asynchronous Background Saving.
1. Create the audio object. 
2. Start saving the audio file
25. When you're done saving, please set the audio object's file in the audio file
3. Happening at the same time as 2.5. Create the meta data VC. 
4. Set the audio Object in the metadata vc. 
5. Let meta data do its thing
6. Update audioobject when save is pressed. 

- Make a profile table view

- Make My Meta-Data VC Use a table view (http://stackoverflow.com/questions/409259/having-a-uitextfield-in-a-uitableviewcell).

-AVaudioPlayer can stream

- Touch down action for pressing down.
- Touch up inside for The Release Action.

- Add a mutable array of people that I follow to each parse user.

- Add hash tags / titles to search by for audio recordings.
	- Automatically uses timestamp created at. Can use custom name and hashtags.



# Similiar Products in the Market
- Soundcloud
- Twitter

- Blip.me
- Voxer
(Less one to one though. More one to many).

# Experimental Ideas:

- Exit Strategy: Make it eventually stream live audio (compete with ustream / soundcloud?). Make it a really easy mobile podcasting / live streaming tool 
and sell it for 99 cents.
- Free iOS version. Paid version for podcasters (?)
	- that integrates with a rails/javascript web app: Profiles, podcasting, analytics, featured tracks, customization, etc.

- Add Geolocation for sound streaming.
	- Part of the discovery, add local rooms (listen to all boradcasts from SOMA).
- Cocktail party audio streaming.
- Cool Parse Examples: https://parse.com/samples
- Cool open source examples: http://maniacdev.com/2010/06/35-open-source-iphone-app-store-apps-updated-with-10-new-apps/

- https://parse.com/tutorials/geolocations . That for geolocation.

- OMNIAUTH !!!
- https://github.com/mgates/omniauth-parse
- Github
- Twitter
etc.


- Add back hash tags later
- Add geotags later. 

# Left Field

http://www.cocoacontrols.com/platforms/ios/controls/svsegmentedcontrol


http://www.cocoacontrols.com/platforms/ios/controls/mbprogresshud


- Totally different App: Soundtracking Your life: Easily share / promote artists you love.
- Totally different App: Merge StackOverflow and Wikipedia (add point functionality to longform knowledge graphs and tutorials). (Incentivize people to create/share free, open source tutorials).
- Totally different App: Running app that integrates with your music (trainer type deal).
- http://attila.tumblr.com/post/21180235691/ios-tutorial-creating-a-chat-room-using-parse-com
- http://cocoawithlove.com/2011/06/process-of-writing-ios-application.html



- http://www.iosdevnotes.com/tag/uipagecontrol/, add 