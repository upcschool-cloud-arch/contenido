# Ticketmonster

This document provides the requirements for implementing a simple application. Feel free to create a High Level Design (HLD) for the required infrastructure, focusing on serverless services, using diagram tools like https://app.diagrams.net.


## Introduction

Our product will allow for proper management of personal and business expenses thanks to its ability to scan documents such as receipts and invoices and send them to our cloud infrastructure, where relevant information will be extracted to classify expenses and prepare them for further analysis.

The company aims to manage the product's operations as efficiently as possible, so serverless technologies will be used whenever possible.

The main components of the system will be:

## Mobile Front End

An Android and iOS application based on web technology that will allow users to create accounts and authenticate.

It will also be possible to scan receipts (associating them with metadata such as current coordinates and scan date) and send them to the cloud.

In addition, basic information and simple searches will be available, typically limited to obtaining all the user's documents between specific dates, by provider, or by location.

Finally, reports of aggregated data (such as a map indicating spending by city, a histogram with daily expenses, important numbers such as total accumulated spending, etc.) can be retrieved.

## Backend Services

One of the services will receive the images along with their metadata, and after checking authentication, store them securely, and index them for fast random retrieval. It will then carry out the process of document analysis, enriching its classification with the obtained data (provider, amount, etc.).

Another service should allow users to retrieve all documents uploaded by themselves, filtering by date, provider, or location.

User registration and authentication should also be implemented.

Finally, some aggregated data should be maintained for supporting basic reporting capabilities. For this MVP we will require to get monthly expenses grouped by different concepts (average daily spending, expenses by city and by provider, total accumulated spending, etc.).
