Project Overview

This app allows users to manage their TCG collectibles, enabling them to search for specific cards, add cards to their collection, and remove them. The app is designed to work on both iOS and Android platforms, across different screen sizes (phones and tablets).

Key Features & Requirements
Platform Support:

The app must support both iOS and Android devices.
It should be responsive across different screen sizes (phones and tablets).
Core Functionality:

Search for Collectibles: Users can search through a list of trading cards or collectibles.
Add Collectibles: Users can add items (cards) to their personal collection.
Remove Collectibles: Users can remove items from their collection.
Bonus Feature (Optional):

Implement Light and Dark Mode to allow users to switch between themes based on their preferences or device settings.
API Integration
The app interacts with a backend service using four API endpoints to manage the TCG collectibles. These endpoints allow users to get a list of products, retrieve user-specific collectibles, and increment or decrement the quantity of specific products in their collection.

API Endpoints:
You have integrated four API endpoints into your Flutter app:

Fetch All Products:

Endpoint: https://yntnedclb9.execute-api.us-east-1.amazonaws.com/dev/products
Purpose: Fetches a list of all available TCG collectibles. This endpoint is likely used for browsing and searching products.
Method: GET
Get User-Specific Products:

Endpoint: https://yntnedclb9.execute-api.us-east-1.amazonaws.com/dev/users/57/products
Purpose: Fetches a list of products that are specific to a user (in this case, user ID 57). This is used to display the user’s collection.
Method: GET
Increment Product Quantity:

Endpoint: https://yntnedclb9.execute-api.us-east-1.amazonaws.com/dev/users/57/products/1/increment
Purpose: Increments the quantity of a specific product (in this case, product ID 1) in the user’s collection. This feature is used when the user adds more of the same product.
Method: POST
Decrement Product Quantity:

Endpoint: https://yntnedclb9.execute-api.us-east-1.amazonaws.com/dev/users/57/products/1/decrement
Purpose: Decrements the quantity of a specific product (product ID 1) in the user’s collection. This feature is used when the user reduces the quantity of the product in their collection.
Method: POST
Authorization Requirements:
For all API requests, you need to include an Authorization header that contains the user's token, as required by the API. This ensures secure communication between your Flutter app and the backend. The header format is:

Authorization: {token}
The token and user ID (like 57) should be requested from the interviewer and used for making API requests in this assignment.

Challenges with the API:
The API can return non-200 status codes (errors), meaning you’ll need to handle error responses effectively in your app.
The API can have slow responses (greater than 5 seconds), which means you might need to implement features like loading indicators or timeouts to improve the user experience while waiting for data.
Status of Your Implementation:
You have successfully integrated the APIs into your Flutter app and are able to:

Retrieve data from the API (i.e., fetching all products and user-specific collectibles).
Post data to the API (i.e., incrementing and decrementing product quantities).
UI Implementation:
The user interface should reflect the following functionalities:

A search bar or search functionality for users to find specific trading cards from the API.
A collection view that shows all the collectibles the user has added.
Buttons or controls to add or remove cards from the user’s collection, which will trigger the increment and decrement API endpoints.
Responsive design to handle different screen sizes (phone vs. tablet) and platforms (iOS vs. Android).
If implemented, a theme toggle to switch between light and dark mode.
Bonus: Light and Dark Mode:
Although optional, supporting both light and dark mode will enhance the user experience and provide more accessibility. Flutter supports dark mode by using the ThemeData class, which allows you to easily configure the app for light and dark themes.

Error Handling:
Due to the possibility of slow or failed API responses, you should implement robust error handling:

Display a loading indicator while waiting for API responses.
Show user-friendly error messages if the API fails to respond or returns an error.
Handle timeouts and retry mechanisms, especially for slow responses.
Conclusion:

This TCG Collection app will provide users with an interactive platform to manage their trading card collection. With key features like search, add/remove items, and responsive design, it delivers a seamless experience for both iOS and Android users. You've successfully integrated the necessary APIs, and the next steps include refining the user interface, improving error handling, and possibly implementing light/dark mode.
