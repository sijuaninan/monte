-- Create the matcha database
CREATE DATABASE matcha;

-- Connect to the matcha database
\c matcha;

-- Create user_profile table
CREATE TABLE user_profile (
    id SERIAL PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    mobile VARCHAR(15),
    email VARCHAR(100),
    province_id INT,
    country_id INT,
    color_pref_id INT,
    description TEXT,
    quote TEXT,
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    status BOOLEAN,
    current_gps_coordinates VARCHAR(50),
    online_status BOOLEAN
);

-- Create user_profile_pictures table
CREATE TABLE user_profile_pictures (
    id SERIAL PRIMARY KEY,
    user_id INT REFERENCES user_profile(id),
    picture_blob BYTEA,
    default_profile BOOLEAN,
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    status BOOLEAN
);

-- Create user table
CREATE TABLE "user" (
    id SERIAL PRIMARY KEY,
    user_profile_id INT REFERENCES user_profile(id),
    username VARCHAR(50) UNIQUE,
    password VARCHAR(255),
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    status BOOLEAN
);

-- Create mm_question_type table
CREATE TABLE mm_question_type (
    id SERIAL PRIMARY KEY,
    type_name VARCHAR(50),
    type_desc TEXT,
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    status BOOLEAN
);

-- Create mm_questions table
CREATE TABLE mm_questions (
    id SERIAL PRIMARY KEY,
    type_id INT REFERENCES mm_question_type(id),
    question TEXT,
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    status BOOLEAN
);

-- Create mm_answers table
CREATE TABLE mm_answers (
    id SERIAL PRIMARY KEY,
    user_id INT REFERENCES user_profile(id),
    question_id INT REFERENCES mm_questions(id),
    answer TEXT,
    question_option_id INT,
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP
);

-- Create mm_questions_options table
CREATE TABLE mm_questions_options (
    id SERIAL PRIMARY KEY,
    type_id INT REFERENCES mm_question_type(id),
    option_label VARCHAR(100),
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP
);

-- Create mm_color_pref table
CREATE TABLE mm_color_pref (
    id SERIAL PRIMARY KEY,
    pattern VARCHAR(255),
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP
);

-- Create mm_country table
CREATE TABLE mm_country (
    id SERIAL PRIMARY KEY,
    country_name VARCHAR(100),
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP
);

-- Create mm_province table
CREATE TABLE mm_province (
    id SERIAL PRIMARY KEY,
    province_name VARCHAR(100),
    country_id INT REFERENCES mm_country(id),
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP
);


-- Create mm_city table
CREATE TABLE mm_city (
    id SERIAL PRIMARY KEY,
    city_name VARCHAR(100),
    province_id INT REFERENCES mm_province(id),
    country_id INT REFERENCES mm_country(id),
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP
);

-- Create mm_postal_type table
CREATE TABLE mm_postal_type (
    id SERIAL PRIMARY KEY,
    postal_type VARCHAR(50),
    country_id INT REFERENCES mm_country(id),
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP
);

-- Create mm_postal table
CREATE TABLE mm_postal (
    id SERIAL PRIMARY KEY,
    postal_type_id INT REFERENCES mm_postal_type(id),
    city_id INT REFERENCES mm_city(id),
    province_id INT REFERENCES mm_province(id),
    postal_label VARCHAR(50),
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP
);

-- Create mm_match_status table
CREATE TABLE mm_match_status (
    id SERIAL PRIMARY KEY,
    match_status_name VARCHAR(50),
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    last_updated_by INT
);

-- Create mm_match table
CREATE TABLE mm_match (
    id SERIAL PRIMARY KEY,
    profile1 INT REFERENCES user_profile(id),
    profile2 INT REFERENCES user_profile(id),
    match_status_id INT REFERENCES mm_match_status(id),
    initiated_by INT,
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP
);

-- Sample Data

-- Insert dummy data into the mm_country table
INSERT INTO mm_country (country_name)
VALUES 
('USA'),
('Canada'),
('UK'),
('Australia'),
('India');

-- Insert dummy data into the mm_province table
INSERT INTO mm_province (province_name, country_id)
VALUES 
('California', 1),
('Ontario', 2),
('England', 3),
('New South Wales', 4),
('Maharashtra', 5);

-- Insert dummy data into the mm_city table
INSERT INTO mm_city (city_name, province_id, country_id)
VALUES 
('Los Angeles', 1, 1),
('Toronto', 2, 2),
('London', 3, 3),
('Sydney', 4, 4),
('Mumbai', 5, 5);

-- Insert dummy data into the mm_postal_type table
INSERT INTO mm_postal_type (postal_type, country_id)
VALUES 
('Zip Code', 1),
('Postal Code', 2),
('Postcode', 3),
('Postcode', 4),
('PIN Code', 5);

-- Insert dummy data into the mm_postal table
INSERT INTO mm_postal (postal_type_id, city_id, province_id, postal_label)
VALUES 
(1, 1, 1, '90001'),
(2, 2, 2, 'M5B'),
(3, 3, 3, 'E1 6AN'),
(4, 4, 4, '2000'),
(5, 5, 5, '400001');

-- Insert dummy data into the mm_color_pref table
INSERT INTO mm_color_pref (pattern)
VALUES 
('#FF5733,#33FF57'),
('#3357FF,#57FF33'),
('#FF33A8,#33A8FF'),
('#FF5733,#5733FF'),
('#FF33A8,#A833FF');

-- Insert dummy data into the user_profile table
INSERT INTO user_profile (first_name, last_name, mobile, email, province_id, country_id, color_pref_id, description, quote, status, current_gps_coordinates, online_status)
VALUES
('John', 'Doe', '1234567890', 'john.doe@example.com', 1, 1, 1, 'Lorem ipsum dolor sit amet.', 'To be or not to be', TRUE, '34.052235,-118.243683', TRUE),
('Jane', 'Smith', '1234567891', 'jane.smith@example.com', 2, 2, 2, 'Consectetur adipiscing elit.', 'The unexamined life is not worth living.', TRUE, '43.651070,-79.347015', TRUE),
('Alice', 'Johnson', '1234567892', 'alice.johnson@example.com', 3, 3, 3, 'Sed do eiusmod tempor incididunt.', 'The only thing we have to fear is fear itself.', TRUE, '51.507351,-0.127758', TRUE),
('Bob', 'Brown', '1234567893', 'bob.brown@example.com', 4, 4, 4, 'Ut labore et dolore magna aliqua.', 'That which does not kill us makes us stronger.', TRUE, '-33.868820,151.209290', TRUE),
('Charlie', 'Davis', '1234567894', 'charlie.davis@example.com', 5, 5, 5, 'Ut enim ad minim veniam.', 'In the beginning God created the heavens and the earth.', TRUE, '19.076090,72.877426', TRUE);

-- Insert corresponding data into the user table
INSERT INTO "user" (user_profile_id, username, password, status)
SELECT id, LOWER(first_name) || '.' || LOWER(last_name), 'password123', status
FROM user_profile;

-- Insert dummy data into the user_profile_pictures table
INSERT INTO user_profile_pictures (user_id, picture_blob, default_profile, status)
SELECT id, NULL, TRUE, status
FROM user_profile;

-- Insert dummy data into the mm_question_type table
INSERT INTO mm_question_type (type_name, type_desc, status)
VALUES
('Personality', 'Questions related to personality traits', TRUE),
('Preferences', 'Questions related to personal preferences', TRUE),
('Lifestyle', 'Questions related to lifestyle choices', TRUE),
('Hobbies', 'Questions related to hobbies and interests', TRUE),
('Background', 'Questions related to personal background', TRUE);

-- Insert dummy data into the mm_questions table
INSERT INTO mm_questions (type_id, question, status)
VALUES
(1, 'Are you an introvert or extrovert?', TRUE),
(2, 'Do you prefer coffee or tea?', TRUE),
(3, 'Do you exercise regularly?', TRUE),
(4, 'What is your favorite hobby?', TRUE),
(5, 'Where did you grow up?', TRUE);

-- Insert dummy data into the mm_questions_options table
INSERT INTO mm_questions_options (type_id, option_label)
VALUES
(1, 'Introvert'),
(1, 'Extrovert'),
(2, 'Coffee'),
(2, 'Tea'),
(3, 'Yes'),
(3, 'No'),
(4, 'Reading'),
(4, 'Traveling'),
(5, 'City'),
(5, 'Suburbs');

-- Insert dummy data into the mm_answers table
INSERT INTO mm_answers (user_id, question_id, answer, question_option_id)
VALUES
(1, 1, 'Introvert', 1),
(2, 2, 'Tea', 4),
(3, 3, 'Yes', 5),
(4, 4, 'Traveling', 8),
(5, 5, 'City', 9);

-- Insert dummy data into the mm_match_status table
INSERT INTO mm_match_status (match_status_name)
VALUES
('Initiated'),
('Mutual'),
('Cron match list');

-- Insert dummy data into the mm_match table
INSERT INTO mm_match (profile1, profile2, match_status_id, initiated_by)
VALUES
(1, 2, 1, 1),
(3, 4, 2, 3),
(5, 1, 3, 5),
(2, 3, 1, 2),
(4, 5, 2, 4);
