# realtime-document-editor
Real-Time Collaborative Document Editor

High Level Design

                                      +-----------------------+
                                      |       Users           |
                                      |  (Browser/Frontend)   |
                                      +----------+------------+
                                                 |
                                                 | HTTP (REST) / WebSocket
                                                 v
+----------------------+        +----------------+------------------+
|   S3 + CloudFront    |        |       API Gateway / Load Balancer |
| (Static Web Hosting) |        |   (Routes HTTP + WebSocket calls) |
+----------+-----------+        +----------------+------------------+
           |                                    |
           |                        +-----------+-----------+
           |                        |     WebSocket Servers  |
           |                        |  (Collaborative Engine)|
           |                        +-----------+-----------+
           |                                    |
           |                                    |
           |                        +-----------+------------+
           |                        |   Redis (Elasticache)  |
           |                        |  - Pub/Sub Channels    |
           |                        |  - In-memory Document  |
           |                        +-----------+------------+
           |                                    |
           |                                    |
+----------v-----------+         +-------------v-------------+
|   Document Service   |         |     Auth & Access Layer   |
|  (REST APIs - ECS)   |         |  (User mgmt, tokens, ACL) |
+----------+-----------+         +-------------+-------------+
           |                                     |
     +-----v----------+              +-----------v-----------+
     |   MongoDB Atlas|              |     MySQL (RDS)       |
     | (Doc bodies,    |              | (Users, ACLs, shares) |
     |  versions, ops) |              +-----------------------+
     +-----------------+

                         +-------------------------------+
                         |     Kafka (optional)          |
                         | - Audit Logs, Real-time Feed  |
                         | - Document events stream      |
                         +-------------------------------+

Key Interactions

    Frontend (React/Next.js)

        Connects to WebSocket for real-time editing.

        Calls REST API to load/save documents, manage users, etc.

    WebSocket Servers

        Handle user presence, document updates.

        Coordinate real-time changes via Redis pub/sub.

    Redis

        Maintains active document states.

        Syncs edits across WebSocket server nodes (broadcast model).

    MongoDB

        Stores document structure, content, and version history.

        Can serialize CRDTs or structured deltas.

    MySQL

        Manages users, roles, permissions, sharing.

    Kafka (optional, but useful at scale)

        Logs all operations for audit/versioning/analytics.

        Feeds data pipelines or dashboards.

