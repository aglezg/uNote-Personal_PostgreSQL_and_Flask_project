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
  registration_date TIMESTAMP(0) WITHOUT TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP CHECK (registration_date >= CURRENT_DATE)
);

-- Directories
CREATE TABLE directories (
  id SERIAL PRIMARY KEY,
  name VARCHAR(150) NOT NULL,
  owner_id INT NOT NULL REFERENCES users(id) ON UPDATE CASCADE ON DELETE CASCADE,
  parent_directory_id INT REFERENCES directories(id) ON UPDATE CASCADE ON DELETE CASCADE
);

-- Function to set a default name to a directory if it is a root directory
CREATE OR REPLACE FUNCTION set_default_root_directory_name() RETURNS TRIGGER AS $$
BEGIN
  -- Set default directory name to 'root'
  IF NOT EXISTS (SELECT 1 FROM directories WHERE owner_id = NEW.owner_id) THEN
    IF NEW.parent_directory_id IS NULL THEN
      NEW.name = 'root_user(' || NEW.owner_id || ')';
    ELSE
      RAISE EXCEPTION 'root directory cannot has parent directory id associated';
    END IF;
  END IF;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Trigger before insert on Directories
CREATE TRIGGER trigger_default_root_directory_name
BEFORE INSERT ON directories
FOR EACH ROW
EXECUTE FUNCTION set_default_root_directory_name();

-- Function to check if a user can only has one root directory
CREATE OR REPLACE FUNCTION one_user_one_root_directory() RETURNS TRIGGER AS $$
BEGIN
  IF NEW.parent_directory_id IS NULL AND EXISTS (SELECT 1 FROM directories WHERE owner_id = NEW.owner_id) THEN
    RAISE EXCEPTION 'only one root directory per user can exist';
  END IF;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Trigger before insert on Directories
CREATE TRIGGER trigger_one_user_one_root_directory
BEFORE INSERT OR UPDATE ON directories
FOR EACH ROW
EXECUTE FUNCTION one_user_one_root_directory();

-- Notes
CREATE TABLE notes (
  id SERIAL PRIMARY KEY,
  title VARCHAR(255) NOT NULL DEFAULT 'No title',
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
  owner_id INT NOT NULL REFERENCES users(id) ON UPDATE CASCADE ON DELETE CASCADE,
  directory_id INT NOT NULL REFERENCES directories(id) ON UPDATE CASCADE ON DELETE CASCADE
);

-- Comments
CREATE TABLE comments (
  id SERIAL PRIMARY KEY,
  body TEXT NOT NULL,
  id_note INT NOT NULL REFERENCES notes(id) ON UPDATE CASCADE ON DELETE CASCADE,
  owner_id INT NOT NULL REFERENCES users(id) ON UPDATE CASCADE ON DELETE CASCADE
);