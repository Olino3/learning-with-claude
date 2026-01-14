# Step 1: Basic API Setup

This step creates a minimal Sinatra API that returns JSON responses.

## What's Included
- Basic Sinatra application
- JSON content type for all responses
- Health check endpoint
- API root endpoint

## How to Run
```bash
ruby app.rb
```

## Test Endpoints
```bash
curl http://localhost:4567/
curl http://localhost:4567/api/v1
curl http://localhost:4567/api/v1/health
```
