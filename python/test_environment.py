#!/usr/bin/env python3
"""
Simple Hello World script to test Python environment
"""

def main():
    print("=" * 70)
    print("PYTHON LEARNING ENVIRONMENT TEST")
    print("=" * 70)
    print()
    print("✅ Python is working correctly!")
    print()
    
    # Show Python version
    import sys
    print(f"Python version: {sys.version}")
    print(f"Python executable: {sys.executable}")
    print()
    
    # Show virtual environment
    import os
    venv = os.environ.get('VIRTUAL_ENV', 'Not set')
    print(f"Virtual environment: {venv}")
    print()
    
    # Test basic functionality
    print("Testing basic Python features:")
    numbers = [1, 2, 3, 4, 5]
    squared = [n**2 for n in numbers]
    print(f"  List comprehension: {numbers} -> {squared}")
    print()
    
    print("🎉 Python environment is ready for learning!")
    print("=" * 70)

if __name__ == "__main__":
    main()
