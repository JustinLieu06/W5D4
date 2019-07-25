PRAGMA foreign_keys = ON;

DROP TABLE IF EXISTS question_likes;
DROP TABLE IF EXISTS replies;
DROP TABLE IF EXISTS question_follows;
DROP TABLE IF EXISTS questions;
DROP TABLE IF EXISTS users;

CREATE TABLE users (
  id INTEGER PRIMARY KEY,
  fname VARCHAR(100) NOT NULL,
  lname VARCHAR(100) NOT NULL
);

CREATE TABLE questions (
  id INTEGER PRIMARY KEY,
  title VARCHAR(100) NOT NULL,
  body VARCHAR(400) NOT NULL,
  user_id INTEGER,
  FOREIGN KEY (user_id) REFERENCES users(id)
);

CREATE TABLE question_follows (
  id INTEGER PRIMARY KEY,
  user_id INTEGER,
  question_id INTEGER,
  FOREIGN KEY (user_id) REFERENCES users(id),
  FOREIGN KEY (question_id) REFERENCES questions(id)
);

CREATE TABLE replies (
  id INTEGER PRIMARY KEY,
  body VARCHAR(400) NOT NULL,
  question_id INTEGER,
  reply_id INTEGER,
  user_id INTEGER,
  FOREIGN KEY (question_id) REFERENCES questions(id),
  FOREIGN KEY (reply_id) REFERENCES replies(id),
  FOREIGN KEY (user_id) REFERENCES users(id)
);

CREATE TABLE question_likes (
  id INTEGER PRIMARY KEY,
  user_id INTEGER,
  question_id INTEGER,
  FOREIGN KEY (user_id) REFERENCES users(id),
  FOREIGN KEY (question_id) REFERENCES questions(id)
);

INSERT INTO 
  users (fname, lname)
VALUES
  ('Bob','Smith'),
  ('Jane', 'Doe'),
  ('Justin', 'Bieber'),
  ('Robert', 'Downey'),
  ('Santa', 'Claus');

INSERT INTO
  questions(title, body, user_id)
VALUES
  ('help', 'i need help', 5),
  ('rip', 'cannot fix my stove', 1),
  ('ahhh', 'my hair..fix it', 3),
  ('pls help', 'i died in my most popular franchise', 4),
  ('missing', 'wheres waldo?', 2);

INSERT INTO
  question_follows(user_id, question_id)
VALUES
  (1,1),
  (2,3),
  (3,2),
  (4,4),
  (5,5);

INSERT INTO
  replies(body, question_id, reply_id, user_id)
VALUES
  ('fix it yourself', 2, NULL, 5),
  ('your hair is so cool', 3, NULL, 3),
  ('you cannot be dead', 3, 4, 1),
  ('I am here', 5, NULL, 2),
  ('you are not Waldo', 5, 4, 4);

  INSERT INTO
    question_likes(user_id, question_id)
  VALUES
    (1,1),
    (2,3),
    (3,2);