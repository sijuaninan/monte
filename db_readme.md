<!-- Matcha 


user_profile -> id, first_name, last_name, mobile, email, province_id, country_id, security_questions, color_pref_id, description, quote, created_at, updated_at, status, current_gps_coordinates, online_status

user_profile_pictures -> id, user_id, picture_blob, default_profile(true/false), created_at, updated_at, status
user -> id, user_profile_id, username, password, created_at, updated_at, status
mm_question_type -> id, type_name, type_desc, created_at, updated_at, status
mm_questions -> id, type_id, question, created_at, updated_at, status
mm_answers -> id, user_id, question_id, answer, question_option_id, created_at, updated_at
mm_questions_options -> id, type_id, option_label, created_at, updated_at
mm_color_pref -> id, pattern (color codes `,` separated), created_at, updated_at
mm_province -> id, province_name, country_id, created_at, updated_at 
mm_country ->  id, country_name, created_at, updated_at 
mm_city ->   id, city_name, province_id, country_id, created_at, updated_at 
mm_postal_type -> id, postal_type, country_id, created_at, updated_at (for suppose 4 different countries change the countryID
mm_postal -> id, postal_type_id, city_id,b  province_id, postal_label, created_at, updated_at.
mm_match_status -> id, match_status_name, created_at, updated_at, last_updated_by
Example records for mm_match_status: 1- Initiated, 2-Mutual, 4-Cron match list

mm_match -> id, profile1, profile2, match_status_id, initiated_by, created_at, updated_at -->


Querys

-- Create the matcha database
CREATE DATABASE matcha;

-- Switch to the matcha database
USE matcha;

-- Create user_profile table
CREATE TABLE user_profile (
    id INT PRIMARY KEY AUTO_INCREMENT,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    mobile VARCHAR(15),
    email VARCHAR(100),
    province_id INT,
    country_id INT,
    security_questions TEXT,
    color_pref_id INT,
    description TEXT,
    quote TEXT,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME ON UPDATE CURRENT_TIMESTAMP,
    status TINYINT(1),
    current_gps_coordinates VARCHAR(50),
    online_status TINYINT(1)
);

-- Create user_profile_pictures table
CREATE TABLE user_profile_pictures (
    id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT,
    picture_blob LONGBLOB,
    default_profile TINYINT(1),
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME ON UPDATE CURRENT_TIMESTAMP,
    status TINYINT(1),
    FOREIGN KEY (user_id) REFERENCES user_profile(id)
);

-- Create user table
CREATE TABLE user (
    id INT PRIMARY KEY AUTO_INCREMENT,
    user_profile_id INT,
    username VARCHAR(50) UNIQUE,
    password VARCHAR(255),
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME ON UPDATE CURRENT_TIMESTAMP,
    status TINYINT(1),
    FOREIGN KEY (user_profile_id) REFERENCES user_profile(id)
);

-- Create mm_question_type table
CREATE TABLE mm_question_type (
    id INT PRIMARY KEY AUTO_INCREMENT,
    type_name VARCHAR(50),
    type_desc TEXT,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME ON UPDATE CURRENT_TIMESTAMP,
    status TINYINT(1)
);

-- Create mm_questions table
CREATE TABLE mm_questions (
    id INT PRIMARY KEY AUTO_INCREMENT,
    type_id INT,
    question TEXT,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME ON UPDATE CURRENT_TIMESTAMP,
    status TINYINT(1),
    FOREIGN KEY (type_id) REFERENCES mm_question_type(id)
);

-- Create mm_answers table
CREATE TABLE mm_answers (
    id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT,
    question_id INT,
    answer TEXT,
    question_option_id INT,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES user_profile(id),
    FOREIGN KEY (question_id) REFERENCES mm_questions(id)
);

-- Create mm_questions_options table
CREATE TABLE mm_questions_options (
    id INT PRIMARY KEY AUTO_INCREMENT,
    type_id INT,
    option_label VARCHAR(100),
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (type_id) REFERENCES mm_question_type(id)
);

-- Create mm_color_pref table
CREATE TABLE mm_color_pref (
    id INT PRIMARY KEY AUTO_INCREMENT,
    pattern VARCHAR(255),
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME ON UPDATE CURRENT_TIMESTAMP
);

-- Create mm_province table
CREATE TABLE mm_province (
    id INT PRIMARY KEY AUTO_INCREMENT,
    province_name VARCHAR(100),
    country_id INT,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (country_id) REFERENCES mm_country(id)
);

-- Create mm_country table
CREATE TABLE mm_country (
    id INT PRIMARY KEY AUTO_INCREMENT,
    country_name VARCHAR(100),
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME ON UPDATE CURRENT_TIMESTAMP
);

-- Create mm_city table
CREATE TABLE mm_city (
    id INT PRIMARY KEY AUTO_INCREMENT,
    city_name VARCHAR(100),
    province_id INT,
    country_id INT,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (province_id) REFERENCES mm_province(id),
    FOREIGN KEY (country_id) REFERENCES mm_country(id)
);

-- Create mm_postal_type table
CREATE TABLE mm_postal_type (
    id INT PRIMARY KEY AUTO_INCREMENT,
    postal_type VARCHAR(50),
    country_id INT,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (country_id) REFERENCES mm_country(id)
);

-- Create mm_postal table
CREATE TABLE mm_postal (
    id INT PRIMARY KEY AUTO_INCREMENT,
    postal_type_id INT,
    city_id INT,
    province_id INT,
    postal_label VARCHAR(50),
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (postal_type_id) REFERENCES mm_postal_type(id),
    FOREIGN KEY (city_id) REFERENCES mm_city(id),
    FOREIGN KEY (province_id) REFERENCES mm_province(id)
);

-- Create mm_match_status table
CREATE TABLE mm_match_status (
    id INT PRIMARY KEY AUTO_INCREMENT,
    match_status_name VARCHAR(50),
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME ON UPDATE CURRENT_TIMESTAMP,
    last_updated_by INT
);

-- Create mm_match table
CREATE TABLE mm_match (
    id INT PRIMARY KEY AUTO_INCREMENT,
    profile1 INT,
    profile2 INT,
    match_status_id INT,
    initiated_by INT,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (profile1) REFERENCES user_profile(id),
    FOREIGN KEY (profile2) REFERENCES user_profile(id),
    FOREIGN KEY (match_status_id) REFERENCES mm_match_status(id)
);
