# Edge Alert

A Flutter package that shows alert from top or bottom of the screen.

## How to Use

```yaml
# add this line to your dependencies
edge_alert: ^0.0.1
```

```dart
import 'package:edge_alert/edge_alert.dart';
```

```dart
EdgeAlert.show(context, title: 'Title', description: 'Description', gravity: EdgeAlert.TOP);
```

property | description
--------|------------
context | BuildContext (Not Null)(required)
title   | 'Your title goes here'
description   | 'Your description goes here'
icon    | IconData (Default: Icons.notifications)
backgroundColor | Color() (Default Colors.grey)
duration| EdgeAlert.LENGTH_SHORT(1 second, Default) or EdgeAlert.LENGTH_LONG(2 sec) or EdgeAlert.LENGTH_VERY_LONG(3 sec)
gravity | EdgeAlert.TOP(Default) or EdgeAlert.BOTTOM

