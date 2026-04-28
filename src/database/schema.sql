CREATE DATABASE placeintel_db;
USE placeintel_db;

CREATE TABLE users (
    id INT PRIMARY KEY AUTO_INCREMENT,
    full_name VARCHAR(100),
    email VARCHAR(100) UNIQUE,
    password VARCHAR(100),
    role VARCHAR(20) -- 'admin' or 'student'
);

CREATE TABLE notices (
    id INT PRIMARY KEY AUTO_INCREMENT,
    title VARCHAR(255),
    description TEXT,
    deadline DATE,
    link VARCHAR(255)
);

CREATE TABLE feeds (
    id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT NOT NULL,
    text TEXT,
    file_url LONGTEXT,
    file_name VARCHAR(255) DEFAULT NULL,
    created_at TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE CASCADE
);

CREATE TABLE feed_likes (
    feed_id INT NOT NULL,
    user_id INT NOT NULL,
    PRIMARY KEY (feed_id, user_id),
    FOREIGN KEY (feed_id) REFERENCES feeds (id) ON DELETE CASCADE,
    FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE CASCADE
);

CREATE TABLE feed_comments (
    id INT PRIMARY KEY AUTO_INCREMENT,
    feed_id INT NOT NULL,
    user_id INT NOT NULL,
    text TEXT NOT NULL,
    created_at TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (feed_id) REFERENCES feeds (id) ON DELETE CASCADE,
    FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE CASCADE
);