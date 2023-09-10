# MatchMate
MatchMate is an iOS app that simulates a matrimonial app by displaying match cards, similar to the card format used by platforms like Shaadi.com. The app leverages an API to fetch user data and presents it in a user-friendly list format. Users can interact with these match cards by accepting or declining potential matches. It offers image caching, offline support with CoreData, and follows the MVVM architecture for a smooth and efficient user experience.

## Features

- **Image Caching:** MatchMate optimizes performance by caching user profile images, reducing network requests, and providing a smoother user experience.

- **Offline Support:** MatchMate works seamlessly even when you're offline. It caches user data locally using CoreData, ensuring you can still view and interact with previously fetched profiles.

- **Accept and Decline Functionality:** Make decisions about potential matches with MatchMate and your decisions are stored and reflected in the app's UI.

## Architecture

MatchMate follows the MVVM (Model-View-ViewModel) architecture:

- **Model:** Represents the data and business logic of the application.

- **View:** Represents the user interface and displays data to users.

- **ViewModel:** Acts as an intermediary between the Model and the View. It prepares and formats data from the Model for presentation in the View. It also handles user interactions and updates the Model as needed.
