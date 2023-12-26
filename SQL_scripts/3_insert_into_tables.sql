/**
 * Table insertions
 */

-- Users
INSERT INTO users (name, lastname, lastname2, username, password)
VALUES
  ('Adrian', 'Gonzalez', 'Galvan', 'a__glezg', 'passWd1*'),   -- id 1
  ('Jacob', 'Santana', 'Rodriguez', 'jac_55', 'passWd2*'),    -- id 2
  ('Hector', 'Alonso', null, 'hectillo1', 'passWd3*'),        -- id 3
  ('Rodrigo', 'Rodriguet', null, 'rodris3', 'passWd4*'),      -- id 4
  ('Alejandro', 'Torres', 'Hernandez', 'alee7', 'passWd5*');  -- id 5

-- Directories (roots)
INSERT into directories (owner_id)
VALUES
  (1),  -- id 1
  (2),  -- id 2
  (3),  -- id 3
  (4),  -- id 4
  (5);  -- id 5

-- Directories (non roots)
INSERT INTO directories (name, owner_id, parent_directory_id)
VALUES
  ('myDir1', 1, 1),       -- id 6
  ('myDir2', 1, 1),       -- id 7
  ('BlueNotes', 2, 2),    -- id 8
  ('GreenNotes', 2, 2),   -- id 9
  ('Music', 3, 3),        -- id 10
  ('Work', 3, 3);         -- id 11

-- Notes
INSERT INTO notes(title, body, color, owner_id, directory_id)
VALUES
  ('First note', 'This is my first note!', 'Purple', 1, 6),             -- id 1
  ('Second note', 'This is my second note!', 'Gray', 1, 7),             -- id 2
  ('First Blue Note', 'One fantastic blue note!', 'Blue', 2, 8),        -- id 3
  ('Second Blue Note', 'Another fantastic blue note!', 'Blue', 2, 8),   -- id 4
  ('First Green Note', 'One fantastic green note!', 'Blue', 2, 9),      -- id 5
  ('Second Green Note', 'Another fantastic green note!', 'Blue', 2, 9), -- id 6
  ('To do', 'I have a lot of work to do. Im exhausted!', 'Red', 3, 11); -- id 7

-- Comments
INSERT INTO comments(body, id_note, owner_id)
VALUES
  ('Its super exciting', 1, 1),
  ('I dont think blue is fantastic.', 3, 5),
  ('I like green notes!', 5, 3),
  ('Wow, good luck!', 7, 4);