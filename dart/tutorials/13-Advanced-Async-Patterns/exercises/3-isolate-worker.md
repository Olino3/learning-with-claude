# Exercise 3: Isolate Worker Pool

Build a worker pool using Isolates for parallel processing.

## 📝 Requirements

Create a `WorkerPool` class that:
1. Spawns multiple isolate workers
2. Distributes tasks across workers
3. Returns results via Future
4. Handles worker failures

## 🎯 Example

```dart
void main() async {
  var pool = WorkerPool(workerCount: 4);
  
  var results = await pool.execute((data) {
    // Heavy computation
    return data * data;
  }, [1, 2, 3, 4, 5]);
  
  print(results);  // [1, 4, 9, 16, 25]
  await pool.shutdown();
}
```
