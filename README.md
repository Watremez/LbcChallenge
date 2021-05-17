# LbcChallenge
Challenge project requested by Lbc teams as evaluation


- I've implemented a picture cache system to avoid redownloading pictures that have already been downloaded previously. Unfortunately, I've noticed that accessing to the dictionary that stores the downloaded pictures (or error status) sometimes crashes. I guess it has something to see with concurrent access and that some workaround barriers in concurrent queues could solve the problem. In the meantime, I've simply disabled the feature.

- Since it seems that the official "Le bon coin" app doesn't have a dark theme, I've done the same in my app. To do so, I simply force on the light theme.

- In the detail view, only the ad's description is scrollable thanks to a UITextView. I should embed the whole view below the top image inside a scroll view.

