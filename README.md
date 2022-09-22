# RentRedi Mobile Developer Skills Assessment Solution
![CarouselEmbedded](https://user-images.githubusercontent.com/16603171/191843169-77298c05-9068-49ab-a080-ab35f2b09590.gif)


In this exercise, I was able to successfully create an iOS project using the files that you provided.

In the Main.storyboard file, I created three diffferent ViewControllers
1. `View Controller Scene` - This is the baseline View which was provided for the assessment.
2. `View Controller Used In Current Component Scene` - This is the carousel interface within the baseline View that was provided.
3. `View Controller Used Separately Scene` = This is the carousel interface that is used by itself in a seperate ViewController.
 
Some points I would like to mention.
* Although I was able to successfully compile the code with Firebase, I chose to work around actually using it. I chose to work around populating the Firebase database, because it wasn't a requirement for this assessment.
    * I populated the array of URLs through a MockNetworkManager, which decodes the json file to a `Codable` struct in swift.
* To switch between the ViewController implentations, you just need to move the `Storyboard Entry Point` in the Main.storyboard. It is currently set to `View Controller Used In Current Component Scene`.

