# carsXchange
## Dealer app for carsxchange.com 🔵
- coded by [@sha3rawi33](https://github.com/sha3rawi33) and [@sha3booony](https://github.com/sha3booony) 
- app state management is handled using `Provider`, Google's favourite state management package, check it [here](https://pub.dev/packages/provider)
## Some points to keep in mind
<details>
<summary><h3>A- (Registration)</h3></summary>
	
▶️ App is depending on response status code `201 (Created)` to indecate a successfull user registration, **so keep it `201 (Created)`; not `200 (Ok)` or another status code**.
	
▶️ App is showing a toast containing the status message comming from the backend, **so keep it readable**.
```
{
  "message": "Successfully created user!", // app will show this
  "user": {
    "id": 1,
    ...
```
	
</details>
<details>
<summary><h3>B- (Login)</h3></summary>
	
▶️ App is depending on response status code `200 (Ok)` to indecate a successfull login, **so keep it `200 (Ok)`; not another status code**.

▶️ App is showing a toast containing the status message comming from the backend, **so keep it readable**.
	
▶️ App is depending on `token_type` followed by `access_token` to form the `Autorization` header used later in all user-related requestes. Changing token types (suppose you did) won't affect app as long as you provide a valid header resulting from the compination. I.E: `Basic ZGVtbzpwQDU1dzByZA==`
```
{
  "message": "success login", // app will show this to the user
  "access_token": "37|hPzqGzQZOO4W1c1LOcG9VY1C1PfMuJWagZrDrBaM", 
  "token_type": "Bearer", // app will use this token type followed by the access token 
...
}
```
	
</details>

<details>
<summary><h3>C- (Password reset)</h3></summary>
	
▶️ App is depending on response status code `200 (Ok)` to indecate a successfull password reset, **so keep it `200 (Ok)`; not another status code**.
	
▶️ App is showing a toast containing the status message comming from the backend, **so keep it readable**.

▶️ notice that in case of successfull reset; the toast comes from `status`, and on a non-found email; it comes from `message`; **do not change them**: 
	

```
{
  "success":true,
  "status":"We have emailed your password reset link!" // app will show this
}
```
```
{
  "message":"We can't find a user with that email address.", // app will show this
  "errors":{
...
```
	
</details>

<details>
<summary><h3>D- (Home Screen Car Listing)</h3></summary>
	
▶️ The app does not need the pagination provided to the web page. Hence; we are sending `?source=dealer_app` to the cars endpoint so that it sends un-paginated list. **Keep response structure and always send un-paginated data (cars only).** 

▶️ Flutter apps will always render elements that exist on the viewport only; which will neved eat your phone resources aggressivly as it won't need to render them and keep it saved in memory -the thing that web browsers do- that's why we do not need pagination. The app parses the car list and holds it in memory; and then it renders only the cars on the screen which you can see; keeping the memory free and providing fast scrolling without any laggings.

▶️ If pagination was done; the app would have needed to wait for newer cars to be loaded from the backend (5 by 5) and on scrolling; the user will need to wait for the loading event to complete; causing slowness of the browsing process inside of the app. Why needed? The app is made to make it easier for the dealers to browse all cars in the shortest time possible. 
	
</details>

