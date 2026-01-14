# Solution: Todo Application

This directory contains the complete, working solution for the Todo Application lab.

## Running the Solution

```bash
make sinatra-lab NUM=1
```

The complete application will start at http://localhost:4567

## What's Included

The solution includes all features from the 8-step tutorial:

✅ Basic Sinatra application with routing  
✅ SQLite database with Sequel ORM  
✅ Task and Category models  
✅ ERB templates with layouts  
✅ Full CRUD operations for tasks  
✅ Flash messages for user feedback  
✅ Task filtering by status and category  
✅ Responsive CSS styling  

## Key Files

- `app.rb` - Main Sinatra application with all routes
- `lib/models.rb` - Database models (Task, Category)
- `lib/helpers.rb` - View helper methods
- `views/` - ERB templates for all pages
- `public/css/style.css` - Application styling

## Features

### Task Management
- Create new tasks with title, description, and category
- View all tasks in a clean list view
- Edit existing tasks
- Mark tasks as complete/incomplete
- Delete tasks

### Filtering
- View all tasks
- Filter by completed status
- Filter by category
- Category badges with color coding

### User Experience
- Flash messages for actions (success/error)
- Responsive design
- Clean, modern interface
- Form validation with error messages

## Database Schema

### tasks
- `id` - Primary key
- `title` - Task title (required, 2-100 chars)
- `description` - Task details (optional, max 500 chars)
- `completed` - Boolean completion status
- `category_id` - Foreign key to categories
- `created_at` - Timestamp
- `updated_at` - Timestamp

### categories
- `id` - Primary key
- `name` - Category name
- `created_at` - Timestamp
- `updated_at` - Timestamp

## Learning Outcomes

By studying this solution, you'll understand:

1. **Sinatra Basics**
   - Routing with GET, POST, PUT, DELETE
   - Request and response handling
   - ERB template rendering

2. **Database Integration**
   - Sequel ORM usage
   - Model associations (belongs_to, has_many)
   - Validations and constraints

3. **CRUD Patterns**
   - RESTful route design
   - Form handling and validation
   - Data persistence

4. **Web Development**
   - Session-based flash messages
   - Static asset serving
   - CSS styling and layouts

## Next Steps

Once you've reviewed the solution:

1. Try extending it with new features:
   - Due dates for tasks
   - Task priorities
   - Subtasks or checklist items
   - User accounts

2. Experiment with the code:
   - Change the styling
   - Add new categories
   - Implement search functionality

3. Move to the next lab:
   - [Lab 2: Blog API](../../2-blog-api/steps/1/README.md)
