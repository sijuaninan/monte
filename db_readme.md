Matcha 


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
Example: 1- Initiated, 2-Mutual, 4-Cron match list (Prospect)

mm_match -> id, profile1, profile2, match_status_id, initiated_by, created_at, updated_at
