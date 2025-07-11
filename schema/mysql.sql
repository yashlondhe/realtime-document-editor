✅ 1. MySQL (RDS) — For Structured Data

This will handle:

    Users

    Document metadata

    Sharing and ACLs

    Audit logs (optional)

1. users

CREATE TABLE users (
  id BIGINT PRIMARY KEY AUTO_INCREMENT,
  email VARCHAR(255) UNIQUE NOT NULL,
  name VARCHAR(255),
  password_hash VARCHAR(255), -- Optional if using OAuth
  auth_provider VARCHAR(50), -- e.g., 'google', 'local'
  created_at DATETIME,
  updated_at DATETIME
);

2. documents

CREATE TABLE documents (
  id BIGINT PRIMARY KEY AUTO_INCREMENT,
  doc_uid VARCHAR(64) UNIQUE NOT NULL, -- e.g., UUID
  owner_id BIGINT,
  title VARCHAR(255),
  is_public BOOLEAN DEFAULT FALSE,
  created_at DATETIME,
  updated_at DATETIME,
  FOREIGN KEY (owner_id) REFERENCES users(id)
);

3. document_permissions (ACL table)

CREATE TABLE document_permissions (
  id BIGINT PRIMARY KEY AUTO_INCREMENT,
  document_id BIGINT,
  user_id BIGINT,
  role ENUM('viewer', 'editor', 'owner'),
  granted_by BIGINT,
  created_at DATETIME,
  FOREIGN KEY (document_id) REFERENCES documents(id),
  FOREIGN KEY (user_id) REFERENCES users(id),
  FOREIGN KEY (granted_by) REFERENCES users(id)
);

4. audit_logs (optional)

CREATE TABLE audit_logs (
  id BIGINT PRIMARY KEY AUTO_INCREMENT,
  document_id BIGINT,
  user_id BIGINT,
  action VARCHAR(50), -- e.g., 'edit', 'share', 'delete'
  metadata JSON,      -- Extra context: { "field": "title", "from": "A", "to": "B" }
  created_at DATETIME,
  FOREIGN KEY (document_id) REFERENCES documents(id),
  FOREIGN KEY (user_id) REFERENCES users(id)
);