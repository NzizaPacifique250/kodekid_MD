# Python Execution Backend Setup Guide

This guide explains how to set up a Python execution backend for the KodeKid app.

## Option 1: FastAPI Backend (Recommended)

### Step 1: Create a FastAPI Server

Create a file `python_executor.py`:

```python
from fastapi import FastAPI, HTTPException
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel
import subprocess
import tempfile
import os

app = FastAPI()

# Enable CORS for Flutter app
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # In production, specify your Flutter app's domain
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

class CodeRequest(BaseModel):
    code: str
    language: str = "py"

class CodeResponse(BaseModel):
    success: bool
    output: str
    error: str

@app.post("/execute", response_model=CodeResponse)
async def execute_code(request: CodeRequest):
    if request.language != "py":
        raise HTTPException(status_code=400, detail="Only Python is supported")
    
    # Security: Limit code length
    if len(request.code) > 10000:
        raise HTTPException(status_code=400, detail="Code too long")
    
    try:
        # Create a temporary file
        with tempfile.NamedTemporaryFile(mode='w', suffix='.py', delete=False) as f:
            f.write(request.code)
            temp_file = f.name
        
        try:
            # Execute Python code with timeout
            result = subprocess.run(
                ['python3', temp_file],
                capture_output=True,
                text=True,
                timeout=10,
                cwd=tempfile.gettempdir()
            )
            
            output = result.stdout
            error = result.stderr
            
            return CodeResponse(
                success=result.returncode == 0,
                output=output,
                error=error
            )
        finally:
            # Clean up temporary file
            if os.path.exists(temp_file):
                os.unlink(temp_file)
                
    except subprocess.TimeoutExpired:
        return CodeResponse(
            success=False,
            output="",
            error="Code execution timed out (max 10 seconds)"
        )
    except Exception as e:
        return CodeResponse(
            success=False,
            output="",
            error=f"Execution error: {str(e)}"
        )

if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="0.0.0.0", port=8000)
```

### Step 2: Install Dependencies

```bash
pip install fastapi uvicorn python-multipart
```

### Step 3: Run the Server

```bash
python python_executor.py
```

The server will run on `http://localhost:8000`

### Step 4: Update Flutter App

In `lib/features/lessons/data/python_execution_service.dart`, set:

```dart
static const String? _apiUrl = 'http://localhost:8000/execute';
```

For production, replace `localhost` with your server's public IP or domain.

## Option 2: Flask Backend (Simpler)

### Step 1: Create a Flask Server

Create a file `python_executor.py`:

```python
from flask import Flask, request, jsonify
from flask_cors import CORS
import subprocess
import tempfile
import os

app = Flask(__name__)
CORS(app)  # Enable CORS for Flutter app

@app.route('/execute', methods=['POST'])
def execute_code():
    data = request.get_json()
    code = data.get('code', '')
    language = data.get('language', 'py')
    
    if language != 'py':
        return jsonify({
            'success': False,
            'output': '',
            'error': 'Only Python is supported'
        }), 400
    
    # Security: Limit code length
    if len(code) > 10000:
        return jsonify({
            'success': False,
            'output': '',
            'error': 'Code too long'
        }), 400
    
    try:
        # Create a temporary file
        with tempfile.NamedTemporaryFile(mode='w', suffix='.py', delete=False) as f:
            f.write(code)
            temp_file = f.name
        
        try:
            # Execute Python code with timeout
            result = subprocess.run(
                ['python3', temp_file],
                capture_output=True,
                text=True,
                timeout=10
            )
            
            return jsonify({
                'success': result.returncode == 0,
                'output': result.stdout,
                'error': result.stderr
            })
        finally:
            # Clean up temporary file
            if os.path.exists(temp_file):
                os.unlink(temp_file)
                
    except subprocess.TimeoutExpired:
        return jsonify({
            'success': False,
            'output': '',
            'error': 'Code execution timed out (max 10 seconds)'
        })
    except Exception as e:
        return jsonify({
            'success': False,
            'output': '',
            'error': f'Execution error: {str(e)}'
        })

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000, debug=True)
```

### Step 2: Install Dependencies

```bash
pip install flask flask-cors
```

### Step 3: Run the Server

```bash
python python_executor.py
```

The server will run on `http://localhost:5000`

### Step 4: Update Flutter App

In `lib/features/lessons/data/python_execution_service.dart`, set:

```dart
static const String? _apiUrl = 'http://localhost:5000/execute';
```

## Option 3: Deploy to Cloud

### Heroku

1. Create a `Procfile`:
```
web: uvicorn python_executor:app --host 0.0.0.0 --port $PORT
```

2. Create `requirements.txt`:
```
fastapi==0.104.1
uvicorn==0.24.0
python-multipart==0.0.6
```

3. Deploy:
```bash
heroku create your-app-name
git push heroku main
```

### Railway / Render

Similar process - deploy your FastAPI or Flask app and use the provided URL.

## Security Considerations

⚠️ **IMPORTANT**: Code execution is dangerous! Consider:

1. **Sandboxing**: Use Docker containers or VMs to isolate execution
2. **Resource Limits**: Limit CPU, memory, and execution time
3. **Input Validation**: Validate and sanitize code before execution
4. **Rate Limiting**: Prevent abuse with rate limiting
5. **Authentication**: Add API keys or authentication for production
6. **Network Restrictions**: Block network access from executed code
7. **File System**: Use read-only file systems or temporary directories

## Testing

Test your backend with:

```bash
curl -X POST http://localhost:8000/execute \
  -H "Content-Type: application/json" \
  -d '{"code": "print(\"Hello, World!\")", "language": "py"}'
```

Expected response:
```json
{
  "success": true,
  "output": "Hello, World!\n",
  "error": ""
}
```

## Update Flutter App

Once your backend is running, update `python_execution_service.dart`:

```dart
static const String? _apiUrl = 'https://your-backend-url.com/execute';
```

Make sure to handle HTTPS in production!

