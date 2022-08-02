# Task

Develop an app that allows users to select smart vehicles after login to book and ride. App was made using Agile development approach and following design made in Figma.

# Tools used

for UI: UIKit with XIBs for custom UITableViewCells, SnapKit and Cosmos

for networking: Kingfisher, PromiseKit and Alamofire

for other features: AVFoundation, CoreLocation, MapKit, Timer, ReachabilitySwift, UserDefaults

# Architecture

src

└── Resources (custom fonts, videos and varoius files if needed)

└── Services (Services which communicate with multuple parts of the app, for example, LocationService, UserSession, etc.)

└── Extensions 

└── Components (Reusable components)

└── Scenes (ViewControllers)

└── Networking (Backend communication)

└── Models

└── Helpers (App Utillity)

└── Initialization (App and scene delegates)

# Data Source

Data is fetched from API connected to Profico's internal dev server. 
Networking was used for login (authentication token saved to UserDefaults), for every other network call authorization token was required.
Other networking calls were for: getting all available vehicles with GET request in form of JSON data, POST request for booking and canceling rides.
All API calls where performed with Alamofire and returned promise values. Network calls where only able to perform if user had internet connection, otherwise funcitionality was blocked and waited for connection. If user had no internet connection actions were blocked with ReachabilitySwift. 

# Feature overview

## Login screen 

User had the abillity to toggle password visibillity on and off, and if credentials were incorrect text that indicates that appeared. When user started typing UITextField Color changed

<img width="341" alt="Screenshot 2022-08-02 at 01 40 18" src="https://user-images.githubusercontent.com/84441240/182262850-9d94d765-2385-46a4-87f9-b8cfa71ba283.png">             <img width="355" alt="Screenshot 2022-08-02 at 01 39 55" src="https://user-images.githubusercontent.com/84441240/182262845-07961676-5ac3-44fc-949d-5e177cf6f512.png">


## Vehicle List

Vehicles where fetched from API and displayed in UITableView with custom cells. Vehicles were sorted by distance. User had the ability to change his location and to tap on the vehicle to see more details. User also had the ability to scan and start the ride directly from this screen. If the user entered the app while not having internet connection, spinner would show that would only go away when connected again. Also if no vehicles where available at the moment, screen would show empty view with text "no available vehicles".


<img width="400" alt="Screenshot 2022-08-02 at 01 54 07" src="https://user-images.githubusercontent.com/84441240/182263992-873b7bb1-2d91-499c-8da5-13fc80c5e8bd.png">

## QR Code scanning

When selecting scan at the bottom of the list, user would be navigated to this screen, screen only accepted valid qr codes and would show message "invalid qr code" if scanned code was, indeed invalid. If user navigated to this screen after tapping on one of the vehicles, scanner would only accept that vehicle's code. User also had the abillity to toggle the flash on and off. If user had no internet connection, start ride button would disable

![8AE53673-DDEB-4F4F-876B-DF5E0CB4A03A](https://user-images.githubusercontent.com/84441240/182265074-e6de3c99-833b-4d80-bd9b-f1f747f7a2c9.JPEG)

## Ride in progress screen

Ride in progress displays custom circular progress view with timer and custom slider to finish the ride. Timer would continue even if app was destroyed, and this would become the inital screen if user enters first time after starting the ride beforehand.

![707B0A57-CEBB-4259-ADF1-56A3B522BD0C](https://user-images.githubusercontent.com/84441240/182265820-518f1799-1811-4f0e-817e-208ac9952be9.JPEG)

## Ride completed screen

This screen displays user's drive statistics and asks user for feedback in shape of star rating system. Complete ride button takes user to inital Vehicle List screen. 

![BF4DE1A4-913E-44A1-8817-09A4DAC7FCC7](https://user-images.githubusercontent.com/84441240/182266686-4587a352-de9f-4f61-a3d6-d9436dccde73.jpg)

# Project timeline

Project was completed in two week period, in total of two one-week sprints. First week was mostly user interface and project setup, second week was mostly for connecting to backend and error handling. 

