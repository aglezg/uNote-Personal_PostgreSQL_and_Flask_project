/**
 * Table creations
 */

-- Users
CREATE TABLE users (
  id SERIAL PRIMARY KEY,
  name VARCHAR(50) NOT NULL,
  lastname VARCHAR(50) NOT NULL,
  lastname2 VARCHAR(50),
  username VARCHAR(50) NOT NULL UNIQUE,
  password VARCHAR(255) NOT NULL CHECK (
    LENGTH(password) >= 8 AND
        password ~ '[A-Z]' AND
        password ~ '[a-z]' AND
        password ~ '[0-9]' AND
        password ~ '[!@#$%^&*(),.?":{}|<>]'
  ),
  registration_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP CHECK (registration_date >= CURRENT_DATE)
);

-- Directories
CREATE TABLE directories (
  id SERIAL PRIMARY KEY,
  name VARCHAR(150) NOT NULL,
  owner_id INT REFERENCES users(id) ON UPDATE CASCADE ON DELETE CASCADE
);

-- Function to set a default name to a directory
CREATE OR REPLACE FUNCTION set_default_directory_name() RETURNS TRIGGER AS $$
BEGIN
  -- Set default directory name
  NEW.name = 'directory_(' || id || ')';
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_default_directory_name
BEFORE INSERT ON directories
FOR EACH ROW
EXECUTE FUNCTION set_default_directory_name();

-- Notes
CREATE TABLE notes (
  id SERIAL PRIMARY KEY,
  title VARCHAR(255) DEFAULT 'No title',
  body TEXT,
  color VARCHAR(10) NOT NULL CHECK (
    color in (
      'Red',
      'Green',
      'Orange',
      'Blue',
      'White',
      'Black',
      'Gray',
      'Yellow',
      'Purple',
      'Brown',
      'Pink'
    )
  ),
  owner_id INT REFERENCES users(id) ON UPDATE CASCADE ON DELETE CASCADE,
  directory_id INT REFERENCES directories(id) ON UPDATE CASCADE ON DELETE CASCADE
);

-- Comments
CREATE TABLE comments (
  id SERIAL PRIMARY KEY,
  body TEXT NOT NULL,
  id_note INT REFERENCES notes(id) ON UPDATE CASCADE ON DELETE CASCADE,
  owner_id INT REFERENCES users(id) ON UPDATE CASCADE ON DELETE CASCADE
);