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

<details>
  <summary>Show/Hide code</summary>

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