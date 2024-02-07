# notee

Notee is a simple note taking app built with Flutter and Bloc for state management.
I have used the following packages:
- [bloc](https://pub.dev/packages/bloc) for state management
- [go_router](https://pub.dev/packages/go_router) for routing
- [hive](https://pub.dev/packages/hive) for local storage
- [hive_flutter](https://pub.dev/packages/hive_flutter) for local storage
- [flutter](https://flutter.dev/) for building the app

## Features
- Add a note
- Edit a note
- Delete a note
- View a note
- View all notes
- Search for a note

## Project structure
```
lib/
    bloc/ # State management
    models/ # Data models
    pages/ # Pages
    stores/ # Data stores/Repositories
    main.dart # Main entry point
    router.dart # App router
```

## Test coverage
```
lib/
    bloc/ # 100%
    stores/ # 100%
```

## How to run, build and test
- For running the app, you can use the following command:
```
flutter run
```

- For building the app, you can use the following command:
```
flutter build apk/ios
```

- For running the tests, you can use the following command:
```
flutter test 
```

