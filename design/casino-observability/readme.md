### Task description
Vault - responsible for our payments gateway, and keeps an internal database for user account balances, as well as transaction history, credit/debits for wins/losses,
currencies exchange rates, etc.
 
Concierge - our rewards microservice, which tracks player volume, vip points, and leaderboard points, as well as their tier/level and the amount of volume required to reach
new levels. These reward events use an amazon managed Kafka cluster (MSK).
 
Room-Service - responsible for socket.io updates on the client (e.g. deposits updating your balance, chat, level up notifications)

These microservices are deployed in AWS in an ECS cluster. They are behind a public application loadbalancer (ALB). The client is a react SPA, deployed to S3 with Cloudfront.
 
Given this brief description of the platform, design an observability, logging, and alerting strategy.
 
Some mission-critical areas include ensuring:
- Bets are being processed correctly
- Rewards are being calculated properly
- Users are not abusing the system (attempting to bet more than is allowed by the client, forcing rollbacks, etc)
- Users are able to deposit and withdraw supported currencies
- Uptime monitoring for various services, e.g. "Customer chat is down"
- Feel free to add anything else you think would be helpful to monitor as a casino admin
 
You can use any tools you're most comfortable with, please come prepared to discuss your solutions. Architecture diagrams, code samples, or presentations are appreciated but not required

### Solution 


Solution would have at least 3 layers 

1. Application design and clustering 

Each of 3 services have external dependencies: database, Kafka queue, socket.io
Containerised ( ECS, EKS ) must have proper healthchecks 

healthchecks: 

<details>
  <summary>Show healthchecks/Hide healthchecks</summary>

  ```python
  # Code example

  livenessProbe:
  httpGet:
    path: /liveness
    port: 3000
  initialDelaySeconds: 30
  periodSeconds: 10
readinessProbe:
  httpGet:
    path: /health
    port: 3000
  initialDelaySeconds: 30
  periodSeconds: 30
----------------------------------------  
const express = require('express');
const { Kafka } = require('kafkajs');
const mongoose = require('mongoose'); // Example for MongoDB
// const { Client } = require('pg'); // Uncomment for PostgreSQL

const app = express();
const PORT = process.env.PORT || 3000;

// Database settings - replace with your own
const DB_URI = process.env.DB_URI || 'mongodb://localhost:27017/myapp';

// Kafka settings - replace with your own
const KAFKA_BROKERS = (process.env.KAFKA_BROKERS || 'localhost:9092').split(',');
const KAFKA_CLIENT_ID = process.env.KAFKA_CLIENT_ID || 'health-check-client';

// Connect to database (MongoDB example)
mongoose.connect(DB_URI);
const db = mongoose.connection;

// Initialize Kafka client
const kafka = new Kafka({
  clientId: KAFKA_CLIENT_ID,
  brokers: KAFKA_BROKERS,
});
const producer = kafka.producer();

// Check database health
async function checkDatabaseHealth() {
  try {
    // For MongoDB
    if (db.readyState === 1) {
      return { status: 'ok', message: 'Database connection is healthy' };
    } else {
      return { status: 'error', message: 'Database connection is not established' };
    }
    
    /* For PostgreSQL uncomment:
    const client = new Client();
    await client.connect();
    await client.query('SELECT 1');
    await client.end();
    return { status: 'ok', message: 'Database connection is healthy' };
    */
  } catch (error) {
    return { 
      status: 'error', 
      message: `Database connection failed: ${error.message}` 
    };
  }
}

// Check Kafka health
async function checkKafkaHealth() {
  try {
    // Check connection by attempting to connect to the broker
    await producer.connect();
    await producer.disconnect();
    return { status: 'ok', message: 'Kafka connection is healthy' };
  } catch (error) {
    return { 
      status: 'error', 
      message: `Kafka connection failed: ${error.message}` 
    };
  }
}

// Endpoint for healthcheck
app.get('/health', async (req, res) => {
  const results = {
    service: 'ok',
    timestamp: new Date().toISOString(),
    checks: {}
  };

  // Check database
  results.checks.database = await checkDatabaseHealth();

  // Check Kafka
  results.checks.kafka = await checkKafkaHealth();

  // Determine overall status
  const hasErrors = Object.values(results.checks).some(check => check.status === 'error');
  
  if (hasErrors) {
    results.service = 'error';
    res.status(500);
  } else {
    res.status(200);
  }

  res.json(results);
});

// Simpler liveness probe endpoint
app.get('/liveness', (req, res) => {
  res.status(200).send('OK');
});

// Start the server
app.listen(PORT, () => {
  console.log(`Health check service listening on port ${PORT}`);
});

// Proper handling of termination signals
process.on('SIGTERM', () => {
  console.log('SIGTERM signal received: closing HTTP server');
  // Close connections before terminating
  mongoose.disconnect();
  producer.disconnect();
  process.exit(0);
});


Graceful shutdown: 
 - Stops accepting new connections
 - Properly closes database connections
 - Properly disconnects from Kafka
 - Handles multiple termination signals (SIGTERM, SIGINT)

<details>
  <summary>Show Graceful shutdown/Hide Graceful shutdown</summary>

  ```python
  # Code example



const express = require('express');
const { Kafka } = require('kafkajs');
const mongoose = require('mongoose'); // Example for MongoDB
// const { Client } = require('pg'); // Uncomment for PostgreSQL

const app = express();
const PORT = process.env.PORT || 3000;

// Database settings - replace with your own
const DB_URI = process.env.DB_URI || 'mongodb://localhost:27017/myapp';

// Kafka settings - replace with your own
const KAFKA_BROKERS = (process.env.KAFKA_BROKERS || 'localhost:9092').split(',');
const KAFKA_CLIENT_ID = process.env.KAFKA_CLIENT_ID || 'health-check-client';

// Connect to database (MongoDB example)
mongoose.connect(DB_URI);
const db = mongoose.connection;

// Initialize Kafka client
const kafka = new Kafka({
  clientId: KAFKA_CLIENT_ID,
  brokers: KAFKA_BROKERS,
});
const producer = kafka.producer();

// Check database health
async function checkDatabaseHealth() {
  try {
    // For MongoDB
    if (db.readyState === 1) {
      return { status: 'ok', message: 'Database connection is healthy' };
    } else {
      return { status: 'error', message: 'Database connection is not established' };
    }
    
    /* For PostgreSQL uncomment:
    const client = new Client();
    await client.connect();
    await client.query('SELECT 1');
    await client.end();
    return { status: 'ok', message: 'Database connection is healthy' };
    */
  } catch (error) {
    return { 
      status: 'error', 
      message: `Database connection failed: ${error.message}` 
    };
  }
}

// Check Kafka health
async function checkKafkaHealth() {
  try {
    // Check connection by attempting to connect to the broker
    await producer.connect();
    await producer.disconnect();
    return { status: 'ok', message: 'Kafka connection is healthy' };
  } catch (error) {
    return { 
      status: 'error', 
      message: `Kafka connection failed: ${error.message}` 
    };
  }
}

// Endpoint for healthcheck
app.get('/health', async (req, res) => {
  const results = {
    service: 'ok',
    timestamp: new Date().toISOString(),
    checks: {}
  };

  // Check database
  results.checks.database = await checkDatabaseHealth();

  // Check Kafka
  results.checks.kafka = await checkKafkaHealth();

  // Determine overall status
  const hasErrors = Object.values(results.checks).some(check => check.status === 'error');
  
  if (hasErrors) {
    results.service = 'error';
    res.status(500);
  } else {
    res.status(200);
  }

  res.json(results);
});

// Simpler liveness probe endpoint
app.get('/liveness', (req, res) => {
  res.status(200).send('OK');
});

// Start the server with a reference we can close later
const server = app.listen(PORT, () => {
  console.log(`Health check service listening on port ${PORT}`);
});

// Track in-flight requests
let connections = 0;
let shuttingDown = false;

// Count connections
server.on('connection', connection => {
  connections++;
  connection.on('close', () => {
    connections--;
  });
});

// Enhanced graceful shutdown implementation
async function gracefulShutdown(signal) {
  console.log(`${signal} signal received: starting graceful shutdown`);
  
  // Mark as shutting down - will be used for health checks
  shuttingDown = true;
  
  // Stop accepting new connections
  server.close(() => {
    console.log('HTTP server closed, all requests have completed');
  });
  
  // Add a timeout to ensure we don't hang indefinitely
  let forcedShutdownTimeout = setTimeout(() => {
    console.log('Forcing shutdown after timeout');
    process.exit(1);
  }, 30000); // 30 seconds timeout for graceful shutdown
  
  // Wait for connections to drain with periodic logging
  let shutdownInterval = setInterval(() => {
    console.log(`Waiting for ${connections} connections to close...`);
    if (connections === 0) {
      clearInterval(shutdownInterval);
      clearTimeout(forcedShutdownTimeout);
      performCleanup();
    }
  }, 1000);
  
  // Update health check during shutdown
  app.get('/health', (req, res) => {
    res.status(503).json({
      service: 'shutting_down',
      timestamp: new Date().toISOString(),
      message: 'Service is shutting down gracefully'
    });
  });
}

// Cleanup resources
async function performCleanup() {
  console.log('Cleaning up resources...');
  
  try {
    // Disconnect from database
    console.log('Closing database connection...');
    await mongoose.disconnect();
    console.log('Database connection closed');
    
    // Disconnect from Kafka
    console.log('Closing Kafka connection...');
    await producer.disconnect();
    console.log('Kafka connection closed');
    
    console.log('Cleanup completed, exiting process');
    process.exit(0);
  } catch (error) {
    console.error('Error during cleanup:', error);
    process.exit(1);
  }
}

// Handle termination signals
process.on('SIGTERM', () => gracefulShutdown('SIGTERM'));
process.on('SIGINT', () => gracefulShutdown('SIGINT'));