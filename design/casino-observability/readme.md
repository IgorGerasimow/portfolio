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
