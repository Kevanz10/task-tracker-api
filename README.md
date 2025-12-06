# Task Tracker API

Ruby on Rails API backend for a Task Tracker application.

## Repository Structure Decision

**Approach: Multi-repo** (separate repositories for backend and frontend)

### Reasoning

Both monorepo and multi-repo have valid use cases. **Multi-repo** was chosen here because the benefits of isolation outweigh the coordination cost for a system with two distinct services:

1. **Separation of Concerns** — Frontend and backend are distinct bounded contexts. The frontend owns presentation and user interaction; the backend owns business logic and data persistence. Separating at the repository level enforces this boundary and prevents accidental coupling. Each repo has its own dependencies, tooling, and test frameworks.

2. **Independent Evolution** — Each repository has one reason to change. The frontend changes for UI/UX reasons; the backend changes for business logic reasons. They can be deployed, scaled, and versioned independently. The API can serve multiple clients (web, mobile) without coupling releases.

3. **Flexibility** — The frontend can be swapped or rewritten without touching the backend. No need to manage Node.js and Ruby dependencies in the same repo, avoiding conflicts and keeping each project's configuration clean.

For a small project, a monorepo could also work. However, multi-repo better reflects real-world production setups and demonstrates understanding of service-oriented architecture.

---

## Tech Stack

- **Framework**: Ruby on Rails 7.2 (API mode)
- **Database**: SQLite3
- **Testing**: RSpec with FactoryBot

## Quick Start

```bash
# Install dependencies
bundle install

# Setup database
rails db:create db:migrate

# Run tests
bundle exec rspec

# Start server
rails server
```

The API runs at `http://localhost:3000`

## API Endpoints

### POST /tasks

Creates a new task.

**Request:**
```bash
curl -X POST http://localhost:3000/tasks \
  -H "Content-Type: application/json" \
  -d '{"task":{"description":"Buy groceries"}}'
```

**Response (201):**
```json
{
  "id": 1,
  "description": "Buy groceries",
  "created_at": "2024-12-05T07:39:11.000Z",
  "updated_at": "2024-12-05T07:39:11.000Z"
}
```

**Error (422):**
```json
{
  "errors": ["Description can't be blank"]
}
```

### GET /tasks

Returns all tasks ordered by creation time (newest first).

**Request:**
```bash
curl http://localhost:3000/tasks
```

**Response (200):**
```json
[
  {
    "id": 2,
    "description": "Second task",
    "created_at": "2024-12-05T08:00:00.000Z",
    "updated_at": "2024-12-05T08:00:00.000Z"
  },
  {
    "id": 1,
    "description": "First task",
    "created_at": "2024-12-05T07:00:00.000Z",
    "updated_at": "2024-12-05T07:00:00.000Z"
  }
]
```

## Frontend Integration

CORS is configured to allow all origins in development.

```javascript
// Create task
const response = await fetch('http://localhost:3000/tasks', {
  method: 'POST',
  headers: { 'Content-Type': 'application/json' },
  body: JSON.stringify({ task: { description: 'New task' } })
});
const task = await response.json();

// List tasks
const tasks = await fetch('http://localhost:3000/tasks').then(r => r.json());
```

## Running Tests

```bash
bundle exec rspec
```
