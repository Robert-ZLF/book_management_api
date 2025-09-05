# Book Management System API

A RESTful API for managing users, books, borrow/return functionality, and user reports.

## Overview

This API provides comprehensive functionality for a digital library system, allowing users to create accounts, borrow and return books, track balances, and generate activity reports.

## API Documentation

### Swagger UI
Interactive API documentation is available via Swagger UI:

- **URL**: http://localhost:3000/api-docs
- **Features**: View endpoint specs, test requests directly in the browser, and export API definitions.
## Endpoints

### User Management

#### Create User
- **URL**: `/users`
- **Method**: `POST`
- **Request Body**:
  ```json
  {
    "user": {
      "name": "Alice Smith",
      "balance": 100.00
    }
  }
  ```
- **Success Response**: `201 Created`

#### Get User Status
- **URL**: `/users/{id}`
- **Method**: `GET`
- **Success Response**: `200 OK`

### Book Management

#### Create Book
- **URL**: `/book_items`
- **Method**: `POST`
- **Request Body**:
  ```json
  {
    "book_item": {
      "title": "Ruby on Rails Guide",
      "stock_quantity": 5
    }
  }
  ```
- **Success Response**: `201 Created`

### Borrow/Return

#### Borrow Book
- **URL**: `/borrow`
- **Method**: `POST`
- **Request Body**:
  ```json
  {
    "user_id": 1,
    "book_item_id": 1,
    "fee": 5.00
  }
  ```
- **Success Response**: `200 OK`

#### Return Book
- **URL**: `/return`
- **Method**: `POST`
- **Request Body**:
  ```json
  {
    "user_id": 1,
    "book_item_id": 1
  }
  ```
- **Success Response**: `200 OK`

### Reports

#### Monthly Report
- **URL**: `/users/{user_id}/reports/monthly?year=2024&month=10`
- **Method**: `GET`

#### Yearly Report
- **URL**: `/users/{user_id}/reports/yearly?year=2024`
- **Method**: `GET`

#### Book Income Statistics
- **URL**: `/book_items/{book_item_id}/income?start_date=2024-01-01&end_date=2024-12-31`
- **Method**: `GET`

## Installation

1. Install dependencies
```bash
bundle install
```

2. Set up database
```bash
rails db:create
rails db:migrate
```

3. Start server
```bash
rails server
```

## Usage Examples

Create a new user:
```bash
curl -X POST http://localhost:3000/api/v1/users \
  -H 'Content-Type: application/json' \
  -d '{"user": {"name": "John Doe", "balance": 100.00}}'
```

Borrow a book:
```bash
curl -X POST http://localhost:3000/api/v1/borrow \
  -H 'Content-Type: application/json' \
  -d '{"user_id": 1, "book_item_id": 1, "fee": 5.00}'
```