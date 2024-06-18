## Features

This package will create the tickets in ADO for all the issued happening in the Application.
You need to provide organization name, project name & access token to create the Tickets.


## Getting started

import 'package:support_zapper/support_zapper.dart';

## Usage

Included short and useful examples for package users. Add longer examples to `/example` folder.

await ExceptionHandler.initialize(
organization: 'your_organization',
project: 'your_project',
accessToken: 'your_token',
userDetails: {'name': 'test'});

ExceptionHandler.createTicket(message: 'Test Custom Ticket');