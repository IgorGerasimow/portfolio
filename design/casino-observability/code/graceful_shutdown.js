// graceful_shutdown.js - Graceful Shutdown Code Example

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

// Start the server and keep a reference for later shutdown
const server = app.listen(PORT, () => {
  console.log(`Service listening on port ${PORT}`);
});

// Track active connections
let connections = 0;
let shuttingDown = false;
server.on('connection', connection => {
  connections++;
  connection.on('close', () => {
    connections--;
  });
});

// Function for graceful shutdown
async function gracefulShutdown(signal) {
  console.log(`${signal} signal received: starting graceful shutdown`);
  shuttingDown = true;
  
  // Stop accepting new connections
  server.close(() => {
    console.log('HTTP server closed, all requests have completed');
  });
  
  // Set a timeout to force shutdown if needed
  let forcedShutdownTimeout = setTimeout(() => {
    console.log('Forcing shutdown after timeout');
    process.exit(1);
  }, 30000); // 30 seconds timeout
  
  // Wait for all active connections to close
  let shutdownInterval = setInterval(() => {
    console.log(`Waiting for ${connections} connections to close...`);
    if (connections === 0) {
      clearInterval(shutdownInterval);
      clearTimeout(forcedShutdownTimeout);
      performCleanup();
    }
  }, 1000);
  
  // Update health check endpoint during shutdown
  app.get('/health', (req, res) => {
    res.status(503).json({
      service: 'shutting_down',
      timestamp: new Date().toISOString(),
      message: 'Service is shutting down gracefully'
    });
  });
}

// Function to clean up resources
async function performCleanup() {
  console.log('Cleaning up resources...');
  try {
    console.log('Closing database connection...');
    await mongoose.disconnect();
    console.log('Database connection closed');
    
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
