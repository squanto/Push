# Goal
Make it really easy to podcast and livestream audio.

# Spec
Push-to-talk audio. 

1. Simple twitter authentication splash screen. (Check)
2. Record simple audio file (record / stop). 
	- Name it.
	- As you enter in details, it's sending in the background.
3. Send to parse. Associate it with the logged in user.
4. Be able to 'log in' to someone's channel
5. Get files as they're recorded to parse and play them. 
6. Modify record button to take files as they're recording, piece them out, and send them to parse. 
7. It automatically scans and 'follows' people you already follow on twitter. ( or gives you the option?)
8. Interact with the Javascript Web App. (Learn javascript with parse?)


TODO:
- Learn about push notifications
	- https://parse.com/apps/pulse--3/push_notifications
	- https://parse.com/docs/ios_guide#push
	- https://parse.com/tutorials/ios-push-notifications (practice this again)
- As you're updating audio
- Add settings for updating / adding email, reseting passwords, etc.


Experimental Ideas:

- Exit Strategy: Make it eventually stream live audio (compete with ustream / soundcloud?). Make it a really easy mobile podcasting / live streaming tool 
and sell it for 99 cents.
- Free iOS version. Paid version that integrates with a rails/javascript web app: Profiles, podcasting, analytics, featured tracks, customization, etc.

- Add Geolocation for sound streaming.
- Cocktail party audio streaming.
- Cool Parse Examples: https://parse.com/samples
- Cool open source examples: http://maniacdev.com/2010/06/35-open-source-iphone-app-store-apps-updated-with-10-new-apps/

- Totally different App: Soundtracking Your life: Easily share / promote artists you love.
- Totally different App: Merge StackOverflow and Wikipedia (add point functionality to longform knowledge graphs and tutorials). (Incentivize people to create/share free, open source tutorials).
- Totally different App: Running app that integrates with your music (trainer type deal).
- http://attila.tumblr.com/post/21180235691/ios-tutorial-creating-a-chat-room-using-parse-com
- http://cocoawithlove.com/2011/06/process-of-writing-ios-application.html


1. Appplication controller
init with nib name is the designated initializer. Alloc init calls init with nib name. (When created with code). When view controller loads with view, it loads with nib.
	
View controller will come on screen. Needs to load up view.
	Goes to nib by default. 
	ViewWillLoad happens before this.
	Loadview - Set up here for doing programmatically
	
viewDidLoad
	After it loads up, outlets are connected. 
	ViewdidLoad once it's been loaded. Set yourself as data source and delegate. Post view loading setup.
	
ViewWillAppear
	For making thing load.
	
	
	