# Tutorial 15: Advanced Error Handling and Debugging

Welcome to advanced error handling in Dart! This tutorial builds on Tutorial 8's exception basics and explores sophisticated error handling patterns, debugging techniques, and production-ready error management strategies.

## 📋 Learning Objectives

By the end of this tutorial, you will:
- Design custom exception hierarchies for domain-specific errors
- Implement Result/Either types for functional error handling
- Analyze and manipulate stack traces effectively
- Use Zone-based error handling for error boundaries
- Master debugging techniques (print debugging, debugger, DevTools)
- Handle errors in async code with proper boundaries
- Implement retry patterns and circuit breakers
- Set up logging and error reporting systems
- Write comprehensive tests for error scenarios

## 🐍➡️🎯 Coming from Python

Python has try/except and context managers, but Dart offers more structured error handling patterns:

| Concept | Python | Dart |
|---------|--------|------|
| Custom exceptions | `class MyError(Exception):` | `class MyError implements Exception` |
| Result type | Libraries like `returns` | Custom `Result<T, E>` or packages |
| Stack trace | `traceback` module | Built-in `StackTrace` object |
| Error boundaries | Manual try/except | `runZoned()` with error handlers |
| Debugger | `pdb`, `breakpoint()` | `debugger()`, DevTools |
| Retry logic | `tenacity` library | Custom or `retry` package |
| Circuit breaker | Manual or libraries | Custom implementation |
| Logging | `logging` module | `logging` package |
| Error context | Exception chaining (3.11+) | Custom error wrapping |

> **📘 Python Note:** Dart's Zone-based error handling is more powerful than Python's context managers for error isolation. Result types provide type-safe error handling unlike Python's exception-based flow!

## 📝 Custom Exception Hierarchies

### Domain-Specific Exceptions

```dart
// Base exception for all application errors
abstract class AppException implements Exception {
  final String message;
  final DateTime timestamp;
  final String? code;
  final StackTrace? stackTrace;
  
  AppException(
    this.message, {
    this.code,
    this.stackTrace,
  }) : timestamp = DateTime.now();
  
  @override
  String toString() => '[$code] $message';
}

// Authentication errors
class AuthException extends AppException {
  AuthException(String message, {String? code})
      : super(message, code: code ?? 'AUTH_ERROR');
}

class InvalidCredentialsException extends AuthException {
  InvalidCredentialsException()
      : super('Invalid username or password', code: 'INVALID_CREDENTIALS');
}

class TokenExpiredException extends AuthException {
  final DateTime expiredAt;
  
  TokenExpiredException(this.expiredAt)
      : super('Authentication token expired', code: 'TOKEN_EXPIRED');
}

// Network errors
class NetworkException extends AppException {
  final int? statusCode;
  final String? url;
  
  NetworkException(
    String message, {
    this.statusCode,
    this.url,
    String? code,
  }) : super(message, code: code ?? 'NETWORK_ERROR');
}

class ConnectionTimeoutException extends NetworkException {
  ConnectionTimeoutException(String url)
      : super('Connection timeout', url: url, code: 'TIMEOUT');
}

class ServerException extends NetworkException {
  ServerException(int statusCode, String url)
      : super(
          'Server error: $statusCode',
          statusCode: statusCode,
          url: url,
          code: 'SERVER_ERROR',
        );
}

void main() {
  try {
    throw InvalidCredentialsException();
  } on AuthException catch (e, stack) {
    print('Auth error: $e');
    print('Occurred at: ${e.timestamp}');
  }
  
  try {
    throw ServerException(500, 'https://api.example.com');
  } on NetworkException catch (e) {
    print('Network error: $e');
    print('URL: ${e.url}');
    print('Status: ${e.statusCode}');
  }
}
```

> **📘 Python Note:** Similar to creating exception hierarchies with `class MyError(Exception)`, but with more structure for typed error properties.

### Exception with Context

```dart
// Exception that wraps another exception with context
class ContextException implements Exception {
  final String context;
  final Object originalException;
  final StackTrace originalStackTrace;
  
  ContextException(
    this.context,
    this.originalException,
    this.originalStackTrace,
  );
  
  @override
  String toString() {
    return 'Context: $context\n'
        'Original: $originalException\n'
        'Stack: $originalStackTrace';
  }
}

// Helper function to add context to errors
T withContext<T>(String context, T Function() fn) {
  try {
    return fn();
  } catch (e, stack) {
    throw ContextException(context, e, stack);
  }
}

void main() {
  try {
    withContext('Processing user data', () {
      withContext('Parsing JSON', () {
        throw FormatException('Invalid JSON');
      });
    });
  } on ContextException catch (e) {
    print(e);
    // Output shows full context chain
  }
}
```

## 📝 Result/Either Types for Functional Error Handling

### Basic Result Type

```dart
// Result type for success/failure
sealed class Result<T, E> {
  const Result();
}

class Success<T, E> extends Result<T, E> {
  final T value;
  const Success(this.value);
}

class Failure<T, E> extends Result<T, E> {
  final E error;
  const Failure(this.error);
}

// Extension methods for Result
extension ResultExtension<T, E> on Result<T, E> {
  // Check if successful
  bool get isSuccess => this is Success<T, E>;
  bool get isFailure => this is Failure<T, E>;
  
  // Get value (throws if failure)
  T get value => switch (this) {
    Success(value: final v) => v,
    Failure(error: final e) => throw StateError('Result is failure: $e'),
  };
  
  // Get error (throws if success)
  E get error => switch (this) {
    Success() => throw StateError('Result is success'),
    Failure(error: final e) => e,
  };
  
  // Map the success value
  Result<U, E> map<U>(U Function(T) fn) => switch (this) {
    Success(value: final v) => Success(fn(v)),
    Failure(error: final e) => Failure(e),
  };
  
  // FlatMap for chaining
  Result<U, E> flatMap<U>(Result<U, E> Function(T) fn) => switch (this) {
    Success(value: final v) => fn(v),
    Failure(error: final e) => Failure(e),
  };
  
  // Get value or default
  T getOrElse(T defaultValue) => switch (this) {
    Success(value: final v) => v,
    Failure() => defaultValue,
  };
  
  // Get value or compute default
  T getOrElseCompute(T Function(E) fn) => switch (this) {
    Success(value: final v) => v,
    Failure(error: final e) => fn(e),
  };
}

// Usage example
Result<int, String> divide(int a, int b) {
  if (b == 0) {
    return Failure('Division by zero');
  }
  return Success(a ~/ b);
}

Result<String, String> validateAge(int age) {
  if (age < 0) {
    return Failure('Age cannot be negative');
  }
  if (age > 150) {
    return Failure('Age seems invalid');
  }
  return Success('Age $age is valid');
}

void main() {
  // Using Result type
  final result1 = divide(10, 2);
  print(result1.isSuccess);  // true
  print(result1.value);       // 5
  
  final result2 = divide(10, 0);
  print(result2.isFailure);  // true
  print(result2.error);       // Division by zero
  
  // Chaining operations
  final result3 = divide(100, 5)
      .map((n) => n * 2)
      .flatMap((n) => divide(n, 4));
  
  print(result3.getOrElse(0));  // 10
  
  // Pattern matching
  final message = switch (validateAge(25)) {
    Success(value: final msg) => msg,
    Failure(error: final err) => 'Error: $err',
  };
  print(message);  // Age 25 is valid
}
```

> **📘 Python Note:** Similar to Python's `returns` library or Rust's Result type. Provides type-safe error handling without exceptions!

### Async Result Type

```dart
// Async version of Result
typedef AsyncResult<T, E> = Future<Result<T, E>>;

// Extension for async results
extension AsyncResultExtension<T, E> on AsyncResult<T, E> {
  Future<Result<U, E>> mapAsync<U>(Future<U> Function(T) fn) async {
    final result = await this;
    return switch (result) {
      Success(value: final v) => Success(await fn(v)),
      Failure(error: final e) => Failure(e),
    };
  }
  
  Future<Result<U, E>> flatMapAsync<U>(
    Future<Result<U, E>> Function(T) fn,
  ) async {
    final result = await this;
    return switch (result) {
      Success(value: final v) => await fn(v),
      Failure(error: final e) => Failure(e),
    };
  }
}

// Safe async operation wrapper
Future<Result<T, E>> tryCatch<T, E>(
  Future<T> Function() fn,
  E Function(Object error, StackTrace stack) onError,
) async {
  try {
    final value = await fn();
    return Success(value);
  } catch (e, stack) {
    return Failure(onError(e, stack));
  }
}

// Example: API call with Result
Future<Result<Map<String, dynamic>, String>> fetchUser(int id) async {
  return tryCatch(
    () async {
      // Simulate API call
      await Future.delayed(Duration(milliseconds: 100));
      if (id <= 0) {
        throw ArgumentError('Invalid user ID');
      }
      return {'id': id, 'name': 'User $id'};
    },
    (error, stack) => 'Failed to fetch user: $error',
  );
}

void main() async {
  // Chain async operations
  final result = await fetchUser(1)
      .mapAsync((user) async => user['name'] as String)
      .flatMapAsync((name) async {
        if (name.isEmpty) {
          return Failure('Name is empty');
        }
        return Success('Hello, $name!');
      });
  
  print(result.getOrElse('Error occurred'));
}
```

## 📝 Stack Trace Manipulation and Analysis

### Capturing and Analyzing Stack Traces

```dart
import 'dart:isolate';

// Custom stack trace utilities
class StackTraceUtils {
  // Get current stack trace
  static StackTrace capture() => StackTrace.current;
  
  // Parse stack trace into frames
  static List<StackFrame> parse(StackTrace trace) {
    final frames = <StackFrame>[];
    final lines = trace.toString().split('\n');
    
    for (var line in lines) {
      if (line.trim().isEmpty) continue;
      
      final match = RegExp(r'#\d+\s+(.+?)\s+\((.+?):(\d+)(?::(\d+))?\)')
          .firstMatch(line);
      
      if (match != null) {
        frames.add(StackFrame(
          function: match.group(1)!,
          file: match.group(2)!,
          line: int.parse(match.group(3)!),
          column: match.group(4) != null ? int.parse(match.group(4)!) : null,
        ));
      }
    }
    
    return frames;
  }
  
  // Filter stack trace (remove framework internals)
  static StackTrace filter(StackTrace trace, {List<String> exclude = const []}) {
    final frames = parse(trace);
    final filtered = frames.where((frame) {
      return !exclude.any((pattern) => frame.file.contains(pattern));
    });
    
    return StackTrace.fromString(
      filtered.map((f) => f.toString()).join('\n'),
    );
  }
  
  // Get calling function
  static String getCallingFunction() {
    final frames = parse(StackTrace.current);
    return frames.length > 1 ? frames[1].function : 'unknown';
  }
}

class StackFrame {
  final String function;
  final String file;
  final int line;
  final int? column;
  
  StackFrame({
    required this.function,
    required this.file,
    required this.line,
    this.column,
  });
  
  @override
  String toString() {
    final col = column != null ? ':$column' : '';
    return '$function ($file:$line$col)';
  }
}

void functionA() => functionB();
void functionB() => functionC();
void functionC() {
  final trace = StackTrace.current;
  print('Full stack trace:');
  print(trace);
  
  print('\nParsed frames:');
  for (var frame in StackTraceUtils.parse(trace)) {
    print('  $frame');
  }
  
  print('\nCalling function: ${StackTraceUtils.getCallingFunction()}');
}

void main() {
  functionA();
}
```

> **📘 Python Note:** Similar to Python's `traceback` module, but stack traces are first-class objects in Dart.

### Custom Stack Trace

```dart
// Create custom stack trace for better error reporting
class CustomStackTrace implements StackTrace {
  final List<String> frames;
  
  CustomStackTrace(this.frames);
  
  factory CustomStackTrace.from(StackTrace original, {
    String? prefix,
    int skipFrames = 0,
  }) {
    final lines = original.toString().split('\n');
    final frames = lines.skip(skipFrames).map((line) {
      return prefix != null ? '$prefix: $line' : line;
    }).toList();
    
    return CustomStackTrace(frames);
  }
  
  @override
  String toString() => frames.join('\n');
}

void main() {
  try {
    throw Exception('Test error');
  } catch (e, stack) {
    final customStack = CustomStackTrace.from(
      stack,
      prefix: 'APP',
      skipFrames: 1,
    );
    print('Custom stack trace:');
    print(customStack);
  }
}
```

## 📝 Zone-Based Error Handling

### Error Boundaries with Zones

```dart
import 'dart:async';

// Zone-based error boundary
void runWithErrorBoundary(
  void Function() body, {
  void Function(Object error, StackTrace stack)? onError,
}) {
  runZoned(
    body,
    onError: (error, stack) {
      if (onError != null) {
        onError(error, stack);
      } else {
        print('Uncaught error: $error');
        print('Stack trace: $stack');
      }
    },
  );
}

// Example with async code
void main() {
  print('Starting application...\n');
  
  runWithErrorBoundary(
    () {
      print('Inside error boundary');
      
      // Synchronous error
      Timer(Duration(seconds: 1), () {
        throw Exception('Timer error!');
      });
      
      // Async error
      Future.delayed(Duration(seconds: 2), () {
        throw Exception('Async error!');
      });
      
      print('Setup complete');
    },
    onError: (error, stack) {
      print('Caught by error boundary:');
      print('Error: $error');
      print('Type: ${error.runtimeType}');
    },
  );
  
  // Keep app running to see async errors
  Future.delayed(Duration(seconds: 3));
}
```

> **📘 Python Note:** Zones are similar to Python's contextvars but with automatic error handling. More powerful than try/except for isolating async errors!

### Zone Values for Context

```dart
// Use zone values to track request context
class RequestContext {
  final String requestId;
  final DateTime timestamp;
  final Map<String, dynamic> metadata;
  
  RequestContext(this.requestId)
      : timestamp = DateTime.now(),
        metadata = {};
}

// Zone key for request context
final _contextKey = Object();

// Get current request context
RequestContext? get currentContext {
  return Zone.current[_contextKey] as RequestContext?;
}

// Run code with request context
T withRequestContext<T>(String requestId, T Function() body) {
  final context = RequestContext(requestId);
  
  return runZoned(
    body,
    zoneValues: {_contextKey: context},
    onError: (error, stack) {
      print('Error in request ${context.requestId}:');
      print('Error: $error');
      print('Timestamp: ${context.timestamp}');
    },
  );
}

// Example usage
void processRequest(String id, bool shouldFail) {
  withRequestContext(id, () {
    print('Processing request ${currentContext?.requestId}');
    
    if (shouldFail) {
      throw Exception('Request failed');
    }
    
    print('Request completed successfully');
  });
}

void main() {
  processRequest('REQ-001', false);
  processRequest('REQ-002', true);
  processRequest('REQ-003', false);
}
```

### Zone Specifications

```dart
// Advanced zone configuration
void runWithCustomZone() {
  final spec = ZoneSpecification(
    print: (self, parent, zone, message) {
      // Custom print handler
      parent.print(zone, '[${DateTime.now()}] $message');
    },
    handleUncaughtError: (self, parent, zone, error, stackTrace) {
      // Custom error handler
      parent.print(zone, '❌ UNCAUGHT ERROR: $error');
    },
  );
  
  runZoned(
    () {
      print('Starting task');
      
      Future.delayed(Duration(seconds: 1), () {
        print('Task in progress');
        throw Exception('Task failed');
      });
      
      print('Task scheduled');
    },
    zoneSpecification: spec,
  );
}

void main() async {
  runWithCustomZone();
  await Future.delayed(Duration(seconds: 2));
}
```

## 📝 Debugging Techniques

### Print Debugging with Style

```dart
// Debug utility class
class Debug {
  static const _colors = {
    'reset': '\x1B[0m',
    'red': '\x1B[31m',
    'green': '\x1B[32m',
    'yellow': '\x1B[33m',
    'blue': '\x1B[34m',
    'magenta': '\x1B[35m',
    'cyan': '\x1B[36m',
  };
  
  static void log(String message, {String color = 'reset'}) {
    final colorCode = _colors[color] ?? _colors['reset'];
    print('$colorCode$message${_colors['reset']}');
  }
  
  static void info(String message) => log('ℹ️  $message', color: 'blue');
  static void success(String message) => log('✅ $message', color: 'green');
  static void warning(String message) => log('⚠️  $message', color: 'yellow');
  static void error(String message) => log('❌ $message', color: 'red');
  
  static void variable(String name, dynamic value) {
    log('📦 $name = $value', color: 'cyan');
  }
  
  static void section(String title) {
    log('\n${'=' * 60}', color: 'magenta');
    log(title.toUpperCase(), color: 'magenta');
    log('=' * 60, color: 'magenta');
  }
  
  static void trace([String? message]) {
    final frames = StackTraceUtils.parse(StackTrace.current);
    final caller = frames.length > 1 ? frames[1] : null;
    
    if (message != null) {
      log('🔍 TRACE: $message', color: 'cyan');
    }
    if (caller != null) {
      log('   at ${caller.function} (${caller.file}:${caller.line})', 
          color: 'cyan');
    }
  }
  
  static void inspect(dynamic object, {String? label}) {
    if (label != null) {
      log('🔬 $label:', color: 'magenta');
    }
    log('Type: ${object.runtimeType}', color: 'cyan');
    log('Value: $object', color: 'cyan');
    log('String: ${object.toString()}', color: 'cyan');
  }
}

void main() {
  Debug.section('Debug Example');
  
  Debug.info('Starting application');
  
  final user = {'name': 'Alice', 'age': 30};
  Debug.variable('user', user);
  
  Debug.warning('This is a warning');
  
  Debug.inspect(user, label: 'User Object');
  
  Debug.trace('Checkpoint reached');
  
  Debug.success('Application started successfully');
  
  Debug.error('Something went wrong!');
}
```

> **📘 Python Note:** Similar to Python's `print()` debugging, but with better formatting and context tracking.

### Debugger Statement

```dart
// Using debugger statement
void complexFunction(int x) {
  final result = x * 2;
  
  // Break here when running in debug mode
  // Use dart run --enable-asserts --pause-isolates-on-start
  debugger(when: result > 100, message: 'Result is large: $result');
  
  print('Result: $result');
}

void main() {
  for (var i = 0; i < 10; i++) {
    complexFunction(i * 20);
  }
}
```

### Assert for Development

```dart
// Use assert for development checks
class BankAccount {
  final String accountNumber;
  double _balance;
  
  BankAccount(this.accountNumber, this._balance) {
    assert(_balance >= 0, 'Balance cannot be negative');
    assert(accountNumber.isNotEmpty, 'Account number required');
  }
  
  void withdraw(double amount) {
    assert(amount > 0, 'Withdrawal amount must be positive');
    assert(amount <= _balance, 'Insufficient funds');
    
    _balance -= amount;
    
    assert(_balance >= 0, 'Balance invariant violated');
  }
  
  double get balance => _balance;
}

void main() {
  // Run with: dart run --enable-asserts
  final account = BankAccount('ACC001', 1000);
  account.withdraw(500);
  print('Balance: ${account.balance}');
  
  // This will fail assertion in debug mode
  try {
    account.withdraw(600);
  } catch (e) {
    print('Error: $e');
  }
}
```

## 📝 Error Boundaries in Async Code

### Async Error Handling Pattern

```dart
// Wrapper for safe async execution
class AsyncSafe {
  static Future<T?> execute<T>(
    Future<T> Function() fn, {
    void Function(Object error, StackTrace stack)? onError,
    T? fallback,
  }) async {
    try {
      return await fn();
    } catch (e, stack) {
      onError?.call(e, stack);
      return fallback;
    }
  }
  
  static Future<Result<T, E>> executeResult<T, E>(
    Future<T> Function() fn,
    E Function(Object error, StackTrace stack) onError,
  ) async {
    try {
      final value = await fn();
      return Success(value);
    } catch (e, stack) {
      return Failure(onError(e, stack));
    }
  }
}

// Stream error handling
class StreamSafe {
  static Stream<T> wrap<T>(
    Stream<T> stream, {
    void Function(Object error)? onError,
    bool cancelOnError = false,
  }) {
    return stream.handleError(
      (error, stack) {
        onError?.call(error);
        if (!cancelOnError) {
          // Continue stream on error
          return;
        }
      },
    );
  }
  
  static Stream<T> transform<T>(
    Stream<T> stream,
    T Function(T) transformer, {
    void Function(Object error)? onError,
  }) async* {
    await for (var item in stream) {
      try {
        yield transformer(item);
      } catch (e) {
        onError?.call(e);
        // Continue processing other items
      }
    }
  }
}

void main() async {
  // Safe async execution
  final result = await AsyncSafe.execute(
    () async {
      await Future.delayed(Duration(milliseconds: 100));
      throw Exception('API Error');
    },
    onError: (e, stack) => print('Caught: $e'),
    fallback: 'default-value',
  );
  
  print('Result: $result');
  
  // Safe stream processing
  final stream = Stream.fromIterable([1, 2, 3, 4, 5]);
  final safeStream = StreamSafe.transform(
    stream,
    (n) {
      if (n == 3) throw Exception('Error at 3');
      return n * 2;
    },
    onError: (e) => print('Stream error: $e'),
  );
  
  await for (var value in safeStream) {
    print('Value: $value');
  }
}
```

### Future Timeout with Error Recovery

```dart
// Timeout with fallback
Future<T> withTimeout<T>(
  Future<T> future,
  Duration timeout, {
  T Function()? onTimeout,
  FutureOr<T> Function()? onTimeoutAsync,
}) async {
  try {
    return await future.timeout(
      timeout,
      onTimeout: () {
        if (onTimeoutAsync != null) {
          return onTimeoutAsync();
        }
        if (onTimeout != null) {
          return onTimeout();
        }
        throw TimeoutException('Operation timed out after $timeout');
      },
    );
  } catch (e) {
    rethrow;
  }
}

void main() async {
  // Example with timeout
  final result = await withTimeout(
    Future.delayed(Duration(seconds: 5), () => 'Success'),
    Duration(seconds: 2),
    onTimeout: () => 'Timed out - using cached value',
  );
  
  print('Result: $result');
}
```

## 📝 Retry Patterns and Circuit Breakers

### Retry Logic

```dart
// Retry configuration
class RetryConfig {
  final int maxAttempts;
  final Duration initialDelay;
  final double backoffMultiplier;
  final Duration maxDelay;
  final bool Function(Object error)? retryIf;
  
  const RetryConfig({
    this.maxAttempts = 3,
    this.initialDelay = const Duration(seconds: 1),
    this.backoffMultiplier = 2.0,
    this.maxDelay = const Duration(seconds: 30),
    this.retryIf,
  });
}

// Retry utility
class Retry {
  static Future<T> execute<T>(
    Future<T> Function() fn, {
    RetryConfig config = const RetryConfig(),
    void Function(int attempt, Object error)? onRetry,
  }) async {
    var attempt = 0;
    var delay = config.initialDelay;
    
    while (true) {
      attempt++;
      
      try {
        return await fn();
      } catch (e) {
        // Check if we should retry
        final shouldRetry = config.retryIf?.call(e) ?? true;
        
        if (attempt >= config.maxAttempts || !shouldRetry) {
          rethrow;
        }
        
        onRetry?.call(attempt, e);
        
        // Wait before retrying
        await Future.delayed(delay);
        
        // Exponential backoff
        delay = Duration(
          milliseconds: (delay.inMilliseconds * config.backoffMultiplier).toInt(),
        );
        
        // Cap at max delay
        if (delay > config.maxDelay) {
          delay = config.maxDelay;
        }
      }
    }
  }
}

// Example usage
Future<String> unreliableApiCall() async {
  final random = DateTime.now().millisecondsSinceEpoch % 3;
  
  await Future.delayed(Duration(milliseconds: 500));
  
  if (random != 0) {
    throw Exception('API temporarily unavailable');
  }
  
  return 'Success!';
}

void main() async {
  try {
    final result = await Retry.execute(
      unreliableApiCall,
      config: RetryConfig(
        maxAttempts: 5,
        initialDelay: Duration(milliseconds: 500),
        backoffMultiplier: 2.0,
        retryIf: (error) {
          // Only retry on specific errors
          return error.toString().contains('temporarily');
        },
      ),
      onRetry: (attempt, error) {
        print('Attempt $attempt failed: $error');
        print('Retrying...');
      },
    );
    
    print('Final result: $result');
  } catch (e) {
    print('All retries failed: $e');
  }
}
```

> **📘 Python Note:** Similar to Python's `tenacity` library, but with type-safe configuration.

### Circuit Breaker Pattern

```dart
// Circuit breaker states
enum CircuitState {
  closed,   // Normal operation
  open,     // Failing, reject requests
  halfOpen, // Testing if service recovered
}

// Circuit breaker implementation
class CircuitBreaker {
  final int failureThreshold;
  final Duration timeout;
  final Duration resetTimeout;
  
  CircuitState _state = CircuitState.closed;
  int _failureCount = 0;
  DateTime? _lastFailureTime;
  
  CircuitBreaker({
    this.failureThreshold = 5,
    this.timeout = const Duration(seconds: 60),
    this.resetTimeout = const Duration(seconds: 30),
  });
  
  CircuitState get state => _state;
  
  Future<T> execute<T>(Future<T> Function() fn) async {
    // Check if circuit should transition to half-open
    if (_state == CircuitState.open) {
      final timeSinceFailure = DateTime.now().difference(_lastFailureTime!);
      if (timeSinceFailure >= resetTimeout) {
        _state = CircuitState.halfOpen;
        print('Circuit breaker: HALF-OPEN (testing)');
      } else {
        throw CircuitBreakerOpenException(
          'Circuit breaker is open. Try again later.',
        );
      }
    }
    
    try {
      final result = await fn().timeout(timeout);
      
      // Success - reset failure count
      if (_state == CircuitState.halfOpen) {
        _state = CircuitState.closed;
        print('Circuit breaker: CLOSED (recovered)');
      }
      _failureCount = 0;
      
      return result;
    } catch (e) {
      _failureCount++;
      _lastFailureTime = DateTime.now();
      
      // Open circuit if threshold reached
      if (_failureCount >= failureThreshold) {
        _state = CircuitState.open;
        print('Circuit breaker: OPEN (too many failures)');
      }
      
      rethrow;
    }
  }
  
  void reset() {
    _state = CircuitState.closed;
    _failureCount = 0;
    _lastFailureTime = null;
    print('Circuit breaker: RESET');
  }
}

class CircuitBreakerOpenException implements Exception {
  final String message;
  CircuitBreakerOpenException(this.message);
  
  @override
  String toString() => message;
}

// Example usage
class ApiClient {
  final CircuitBreaker _breaker = CircuitBreaker(
    failureThreshold: 3,
    resetTimeout: Duration(seconds: 5),
  );
  
  int _callCount = 0;
  
  Future<String> fetchData() async {
    return _breaker.execute(() async {
      _callCount++;
      
      // Simulate failures for first 5 calls
      if (_callCount <= 5) {
        throw Exception('Service unavailable');
      }
      
      return 'Data from API';
    });
  }
}

void main() async {
  final client = ApiClient();
  
  for (var i = 1; i <= 10; i++) {
    print('\n--- Attempt $i ---');
    try {
      final data = await client.fetchData();
      print('✅ Success: $data');
    } catch (e) {
      print('❌ Failed: $e');
    }
    
    await Future.delayed(Duration(seconds: 1));
  }
}
```

## 📝 Logging and Error Reporting

### Structured Logging

```dart
import 'dart:convert';

// Log levels
enum LogLevel {
  debug,
  info,
  warning,
  error,
  critical;
  
  int get value => index;
}

// Log entry
class LogEntry {
  final DateTime timestamp;
  final LogLevel level;
  final String message;
  final String? context;
  final Map<String, dynamic>? data;
  final Object? error;
  final StackTrace? stackTrace;
  
  LogEntry({
    required this.level,
    required this.message,
    this.context,
    this.data,
    this.error,
    this.stackTrace,
  }) : timestamp = DateTime.now();
  
  Map<String, dynamic> toJson() => {
    'timestamp': timestamp.toIso8601String(),
    'level': level.name,
    'message': message,
    if (context != null) 'context': context,
    if (data != null) 'data': data,
    if (error != null) 'error': error.toString(),
    if (stackTrace != null) 'stackTrace': stackTrace.toString(),
  };
  
  @override
  String toString() => jsonEncode(toJson());
}

// Logger class
class Logger {
  final String name;
  final LogLevel minLevel;
  final List<void Function(LogEntry)> _handlers = [];
  
  Logger(this.name, {this.minLevel = LogLevel.info});
  
  void addHandler(void Function(LogEntry) handler) {
    _handlers.add(handler);
  }
  
  void log(
    LogLevel level,
    String message, {
    String? context,
    Map<String, dynamic>? data,
    Object? error,
    StackTrace? stackTrace,
  }) {
    if (level.value < minLevel.value) return;
    
    final entry = LogEntry(
      level: level,
      message: message,
      context: context ?? name,
      data: data,
      error: error,
      stackTrace: stackTrace,
    );
    
    for (var handler in _handlers) {
      handler(entry);
    }
  }
  
  void debug(String message, {Map<String, dynamic>? data}) {
    log(LogLevel.debug, message, data: data);
  }
  
  void info(String message, {Map<String, dynamic>? data}) {
    log(LogLevel.info, message, data: data);
  }
  
  void warning(String message, {Map<String, dynamic>? data, Object? error}) {
    log(LogLevel.warning, message, data: data, error: error);
  }
  
  void error(String message, {
    Map<String, dynamic>? data,
    Object? error,
    StackTrace? stackTrace,
  }) {
    log(LogLevel.error, message, data: data, error: error, stackTrace: stackTrace);
  }
  
  void critical(String message, {
    Map<String, dynamic>? data,
    Object? error,
    StackTrace? stackTrace,
  }) {
    log(LogLevel.critical, message, data: data, error: error, stackTrace: stackTrace);
  }
}

// Console handler
void consoleHandler(LogEntry entry) {
  final icons = {
    LogLevel.debug: '🐛',
    LogLevel.info: 'ℹ️',
    LogLevel.warning: '⚠️',
    LogLevel.error: '❌',
    LogLevel.critical: '🔥',
  };
  
  final icon = icons[entry.level] ?? '';
  print('$icon [${entry.level.name.toUpperCase()}] ${entry.message}');
  
  if (entry.data != null) {
    print('   Data: ${entry.data}');
  }
  
  if (entry.error != null) {
    print('   Error: ${entry.error}');
  }
}

// File handler (simulated)
void fileHandler(LogEntry entry) {
  // In real app, write to file
  // For now, just demonstrate JSON format
  if (entry.level.value >= LogLevel.error.value) {
    print('Would write to error.log: ${entry.toString()}');
  }
}

void main() {
  // Create logger
  final logger = Logger('MyApp', minLevel: LogLevel.debug);
  logger.addHandler(consoleHandler);
  logger.addHandler(fileHandler);
  
  // Log various levels
  logger.debug('Application starting');
  logger.info('User logged in', data: {'userId': 123});
  logger.warning('API response slow', data: {'duration': '5s'});
  
  try {
    throw Exception('Database connection failed');
  } catch (e, stack) {
    logger.error('Failed to connect to database', error: e, stackTrace: stack);
  }
  
  logger.critical('System out of memory', data: {'available': '10MB'});
}
```

> **📘 Python Note:** Similar to Python's `logging` module with structured logging support.

### Error Reporter

```dart
// Error reporting service
class ErrorReporter {
  final Logger _logger;
  final List<Map<String, dynamic>> _errorBuffer = [];
  
  ErrorReporter(this._logger);
  
  void report(
    Object error,
    StackTrace stack, {
    String? context,
    Map<String, dynamic>? metadata,
  }) {
    final errorData = {
      'error': error.toString(),
      'type': error.runtimeType.toString(),
      'stack': stack.toString(),
      'timestamp': DateTime.now().toIso8601String(),
      if (context != null) 'context': context,
      if (metadata != null) 'metadata': metadata,
    };
    
    _errorBuffer.add(errorData);
    _logger.error('Error reported', data: errorData);
    
    // In real app, send to error tracking service
    _sendToService(errorData);
  }
  
  void _sendToService(Map<String, dynamic> errorData) {
    // Simulate sending to external service (Sentry, Bugsnag, etc.)
    print('📡 Sending to error tracking service: ${errorData['error']}');
  }
  
  List<Map<String, dynamic>> getRecentErrors({int limit = 10}) {
    return _errorBuffer.take(limit).toList();
  }
  
  void clear() => _errorBuffer.clear();
}

void main() {
  final logger = Logger('App');
  logger.addHandler(consoleHandler);
  
  final reporter = ErrorReporter(logger);
  
  // Report errors with context
  try {
    throw NetworkException('Connection failed', statusCode: 500, url: '/api/users');
  } catch (e, stack) {
    reporter.report(
      e,
      stack,
      context: 'User API',
      metadata: {
        'userId': 123,
        'action': 'fetch',
      },
    );
  }
  
  print('\nRecent errors: ${reporter.getRecentErrors().length}');
}
```

## 📝 Testing Error Scenarios

### Testing Exceptions

```dart
// Test helper for exceptions
void expectThrows<T extends Object>(
  void Function() fn, {
  String? message,
  bool Function(T)? matching,
}) {
  try {
    fn();
    throw StateError('Expected exception of type $T but none was thrown');
  } on T catch (e) {
    if (matching != null && !matching(e)) {
      throw StateError('Exception did not match predicate: $e');
    }
    print('✅ Caught expected exception: $e');
  } catch (e) {
    throw StateError('Expected exception of type $T but got ${e.runtimeType}: $e');
  }
}

// Test async exceptions
Future<void> expectThrowsAsync<T extends Object>(
  Future<void> Function() fn, {
  String? message,
  bool Function(T)? matching,
}) async {
  try {
    await fn();
    throw StateError('Expected exception of type $T but none was thrown');
  } on T catch (e) {
    if (matching != null && !matching(e)) {
      throw StateError('Exception did not match predicate: $e');
    }
    print('✅ Caught expected async exception: $e');
  } catch (e) {
    throw StateError('Expected exception of type $T but got ${e.runtimeType}: $e');
  }
}

// Example tests
void main() async {
  print('Testing error scenarios:\n');
  
  // Test 1: Specific exception type
  expectThrows<FormatException>(
    () => int.parse('not a number'),
  );
  
  // Test 2: Exception with matching
  expectThrows<NetworkException>(
    () => throw ServerException(500, 'http://api.example.com'),
    matching: (e) => e.statusCode == 500,
  );
  
  // Test 3: Async exception
  await expectThrowsAsync<TimeoutException>(
    () async {
      await Future.delayed(Duration(seconds: 2)).timeout(
        Duration(milliseconds: 100),
      );
    },
  );
  
  // Test 4: Custom exception hierarchy
  expectThrows<AuthException>(
    () => throw InvalidCredentialsException(),
  );
  
  print('\nAll tests passed! ✅');
}
```

### Testing Error Recovery

```dart
// Mock service for testing
class MockService {
  int _callCount = 0;
  final int failUntilCall;
  
  MockService({this.failUntilCall = 3});
  
  Future<String> fetchData() async {
    _callCount++;
    
    if (_callCount < failUntilCall) {
      throw Exception('Service temporarily unavailable');
    }
    
    return 'Success on attempt $_callCount';
  }
  
  void reset() => _callCount = 0;
}

void main() async {
  print('Testing error recovery:\n');
  
  // Test retry logic
  print('Test 1: Retry succeeds');
  final service1 = MockService(failUntilCall: 3);
  
  try {
    final result = await Retry.execute(
      service1.fetchData,
      config: RetryConfig(maxAttempts: 5),
      onRetry: (attempt, error) {
        print('  Retry attempt $attempt');
      },
    );
    print('  Result: $result ✅\n');
  } catch (e) {
    print('  Failed: $e ❌\n');
  }
  
  // Test retry exhaustion
  print('Test 2: Retry exhausted');
  final service2 = MockService(failUntilCall: 10);
  
  try {
    await Retry.execute(
      service2.fetchData,
      config: RetryConfig(maxAttempts: 3),
    );
    print('  Unexpected success ❌\n');
  } catch (e) {
    print('  Expected failure after retries ✅\n');
  }
  
  // Test circuit breaker
  print('Test 3: Circuit breaker');
  final breaker = CircuitBreaker(failureThreshold: 2);
  
  // Fail twice to open circuit
  for (var i = 0; i < 2; i++) {
    try {
      await breaker.execute(() async {
        throw Exception('Service down');
      });
    } catch (e) {
      print('  Call $i failed (expected)');
    }
  }
  
  // Circuit should be open now
  try {
    await breaker.execute(() async => 'Success');
    print('  Unexpected success ❌');
  } on CircuitBreakerOpenException {
    print('  Circuit breaker correctly opened ✅');
  }
}
```

## ✍️ Practice Exercises

See the exercises directory for hands-on practice:

1. `exercises/1-custom-exceptions.md` - Build a custom exception hierarchy for banking
2. `exercises/2-retry-pattern.md` - Implement retry logic with exponential backoff
3. `exercises/3-circuit-breaker.md` - Build a circuit breaker pattern

## 📚 What You Learned

✅ Designing custom exception hierarchies
✅ Implementing Result/Either types for functional errors
✅ Analyzing and manipulating stack traces
✅ Using zones for error boundaries and context
✅ Advanced debugging techniques and tools
✅ Handling async errors with proper boundaries
✅ Implementing retry patterns and circuit breakers
✅ Setting up structured logging and error reporting
✅ Writing comprehensive tests for error scenarios
✅ Building production-ready error handling systems

## 🔜 Next Steps

**Next tutorial: 16-Idiomatic-Dart-Patterns** - Explore Dart idioms, best practices, and design patterns that make your code more maintainable and expressive.

## 💡 Key Takeaways for Python Developers

1. **Exception hierarchies**: Similar to Python but with stronger typing - compile-time safety
2. **Result types**: Alternative to Python's exception-based flow - more explicit error handling
3. **Zones**: More powerful than Python's contextvars - automatic error isolation for async
4. **Stack traces**: First-class objects like Python's traceback, but always available
5. **Debugger**: Use `debugger()` like Python's `breakpoint()` for interactive debugging
6. **Circuit breaker**: Design pattern for resilient services - prevents cascade failures
7. **Structured logging**: Like Python's logging module but with better JSON support
8. **Type-safe errors**: All error handling is fully type-checked at compile time

## 🆘 Common Pitfalls

### Pitfall 1: Catching Too Broadly

```dart
// Wrong - catches everything, including logic errors
void badExample() async {
  try {
    await riskyOperation();
  } catch (e) {
    // Swallows all errors, even bugs!
    print('Error: $e');
  }
}

// Right - catch specific errors
void goodExample() async {
  try {
    await riskyOperation();
  } on NetworkException catch (e) {
    // Handle expected network errors
    print('Network error: $e');
  } on FormatException catch (e) {
    // Handle parsing errors
    print('Format error: $e');
  }
  // Let unexpected errors propagate
}
```

### Pitfall 2: Not Closing Resources in Zones

```dart
// Wrong - resource leak if error occurs
void badExample() {
  final controller = StreamController();
  
  runZoned(() {
    controller.add(1);
    throw Exception('Error!');
    // controller.close() never called
  });
}

// Right - always clean up resources
void goodExample() {
  final controller = StreamController();
  
  try {
    runZoned(
      () {
        controller.add(1);
        throw Exception('Error!');
      },
      onError: (e, s) => print('Error: $e'),
    );
  } finally {
    controller.close();
  }
}
```

### Pitfall 3: Infinite Retry

```dart
// Wrong - could retry forever
Future<void> badExample() async {
  while (true) {
    try {
      await apiCall();
      break;
    } catch (e) {
      // Infinite loop on persistent errors!
      await Future.delayed(Duration(seconds: 1));
    }
  }
}

// Right - limit retry attempts
Future<void> goodExample() async {
  await Retry.execute(
    apiCall,
    config: RetryConfig(maxAttempts: 3),
  );
}
```

### Pitfall 4: Losing Error Context

```dart
// Wrong - loses original error
void badExample() {
  try {
    riskyOperation();
  } catch (e) {
    throw Exception('Operation failed'); // Lost original error!
  }
}

// Right - preserve error context
void goodExample() {
  try {
    riskyOperation();
  } catch (e, stack) {
    throw ContextException('Operation failed', e, stack);
  }
}
```

### Pitfall 5: Not Testing Error Paths

```dart
// Wrong - only test happy path
void badTest() {
  final result = divide(10, 2);
  assert(result == 5);
}

// Right - test error scenarios too
void goodTest() {
  // Test success
  final result1 = divide(10, 2);
  assert(result1 == 5);
  
  // Test error
  expectThrows<ArgumentError>(() => divide(10, 0));
}
```

## 📖 Additional Resources

- [Dart Error Handling Best Practices](https://dart.dev/guides/language/effective-dart/error-handling)
- [Dart Zones](https://api.dart.dev/stable/dart-async/Zone-class.html)
- [Dart DevTools](https://dart.dev/tools/dart-devtools)
- [Stack Trace API](https://api.dart.dev/stable/dart-core/StackTrace-class.html)
- [Exception API](https://api.dart.dev/stable/dart-core/Exception-class.html)
- [Logging Package](https://pub.dev/packages/logging)
- [Retry Package](https://pub.dev/packages/retry)

---

Ready to build bulletproof error handling? Complete the exercises and make your applications resilient! 🚀
