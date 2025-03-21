// healthchecks.js - Healthchecks Code Example

const express = require('express');
const { Kafka } = require('kafkajs');
const mongoose = require('mongoose');

const app = express();
const PORT = process.env.PORT || 3000;

// Connect to the database (MongoDB example)
mongoose.connect('mongodb://localhost:27017/myapp');
const db = mongoose.connection;

// Initialize Kafka client
const kafka = new Kafka({
  clientId: 'health-check-client',
  brokers: (process.env.KAFKA_BROKERS || 'localhost:9092').split(',')
});
const producer = kafka.producer();

// Function to check database health
async function checkDatabaseHealth() {
  try {
    if (db.readyState === 1) {
      return { status: 'ok', message: 'Database connection is healthy' };
    } else {
      return { status: 'error', message: 'Database connection is not established' };
    }
  } catch (error) {
    return { status: 'error', message: `Database connection failed: ${error.message}` };
  }
}

// Function to check Kafka health
async function checkKafkaHealth() {
  try {
    await producer.connect();
    await producer.disconnect();
    return { status: 'ok', message: 'Kafka connection is healthy' };
  } catch (error) {
    return { status: 'error', message: `Kafka connection failed: ${error.message}` };
  }
}

// Endpoint for health check
app.get('/health', async (req, res) => {
  const results = {
    service: 'ok',
    timestamp: new Date().toISOString(),
    checks: {}
  };

  results.checks.database = await checkDatabaseHealth();
  results.checks.kafka = await checkKafkaHealth();

  const hasErrors = Object.values(results.checks).some(check => check.status === 'error');
  if (hasErrors) {
    results.service = 'error';
    res.status(500);
  } else {
    res.status(200);
  }
  res.json(results);
});

// Simple endpoint for liveness probe
app.get('/liveness', (req, res) => {
  res.status(200).send('OK');
});

// Start the server
app.listen(PORT, () => {
  console.log(`Health check service listening on port ${PORT}`);
});

// Handle termination signal (e.g., SIGTERM)
process.on('SIGTERM', () => {
  console.log('SIGTERM signal received: closing HTTP server');
  mongoose.disconnect();
  producer.disconnect();
  process.exit(0);
});
