# Task App Backend API

Backend API for Task App using Node.js, Express, and MongoDB.

## Features

- RESTful API with CRUD operations
- MongoDB database integration
- Error handling
- CORS enabled

## Installation

```bash
npm install
```

## Run Server

```bash
# Development mode with auto-reload
npm run dev

# Production mode
npm start
```

## API Endpoints

### Base URL: `http://localhost:3000/api/tasks`

### Endpoints:

1. **Get All Tasks**

   - `GET /api/tasks`
   - Response: Array of all tasks

2. **Get Task by ID**

   - `GET /api/tasks/:id`
   - Response: Single task object

3. **Create Task**

   - `POST /api/tasks`
   - Body:

   ```json
   {
     "title": "Task title",
     "description": "Task description",
     "priority": "high",
     "dueDate": "2026-01-10"
   }
   ```

4. **Update Task**

   - `PUT /api/tasks/:id`
   - Body: Fields to update

5. **Delete Task**

   - `DELETE /api/tasks/:id`

6. **Toggle Task Completion**
   - `PATCH /api/tasks/:id/toggle`

## Task Model

```javascript
{
  title: String (required),
  description: String,
  completed: Boolean (default: false),
  priority: String (low/medium/high),
  dueDate: Date,
  createdAt: Date,
  updatedAt: Date
}
```

## Environment Variables

Create a `.env` file in the backend directory:

```
MONGODB_URI=your_mongodb_connection_string
PORT=3000
```
