# BabylonDemo

This document provides an overview and discussion of the app's main architecture.

## General Architecture

The app is implemented using RxSwift/RxCocoa and the MVVM design pattern.

## Navigation

The app uses a coordinator which owns the navigation controller and manages the navigation flow of the app. The benefit is that view controllers don't need to know about any other view controllers and can thus be better reused.

## Data Loaders

The feed loader provides a data loading service to the application and is composed of a separate network service and a local persistence store. The feed loader manages the synchronization of these and provides a unified interface for the app to consume.

## View Models

View models consist of inputs and outputs which views can use to trigger user events and subscribe to observable sequences. The view model is responsible for transforming loaded data into a format the view can use (i.e. transformation of inputs to outputs).

## Views

Views bind the view model's output to its UI elements and passes on user action to the view model. It also contains simple view logic, e.g. when to show error messages.

## Testing

The project includes unit and UI tests. A particular focus is placed on making use of dependency injection which enables the use of mock data. 

## Takeaways

Being a newcomer to reactive programming it took me a while to wrap my head around RxSwift. But once the beast was sufficiently tamed the benefits became quite apparent. Thinking in terms of value streams that flow through the app made my code much better to read and understand. It also made certain tasks surprisingly easier, like binding UI elements and handling errors. Furthermore, MVVM felt like a natural fit along side RxSwift and I really liked how it clearly separated the business logic (view model) from the view which is sometimes difficult to achieve in MVC.

The main challenge was that the learning curve can be quite intimidating. It certainly took some iterations until I achieved what I initially had in mind. Making extensive use of closures also made it imperative to be on the lookout for potential retain cycles. Still, I really enjoyed learning RxSwift and I'm certain that the benefits outweigh the costs, especially as an application becomes increasingly more complex.
